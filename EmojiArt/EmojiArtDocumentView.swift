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
                    }
                }
            }
            .padding(.horizontal)
            Rectangle().foregroundColor(.yellow)
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                // Public image is a URI that covers anything that falls under the specification of an image
                // NSObject providers provide information thats being dropped
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    return drop(providers: providers)
                }
        }
    }
    
    // Load a URL from the provider
    private func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            document.setBackgroundURL(url)
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}
