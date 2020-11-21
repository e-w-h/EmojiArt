//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/16/20.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    // Using an identifiable so that ForEach can iterate through the array
                    // Everything in Swift has an invisible var called self
                    // Swift has syntax called keypath that specifies the var on the object using backslash
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            // Used to convert coordinates
            GeometryReader { geometry in
                ZStack {
                    // Color can be specified as a view
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                    )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * zoomScale)
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
                // Ensures that emoji bar is always visible by limiting (clipping) the image to the boundaries of the canvas view
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                // Public image is a URI that covers anything that falls under the specification of an image
                // Public text covers the emojis that we want to drop
                // NSObject providers provide information thats being dropped
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    // Convert from iOS coordinate system to custom center grid positioning (0,0 in middle instead of upper left)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return drop(providers: providers, at: location)
                }
            }
        }
    }
    
    // UI/visual temporary state
    // Zoomscale is a ratio for how much were zoomed in or out
    @State private var zoomScale: CGFloat = 1.0
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.zoomScale = min(hZoom, vZoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
        return location
    }
    
    // Load a URL from the provider
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            document.setBackgroundURL(url)
        }
        // Loading a string instead of a URL
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}
