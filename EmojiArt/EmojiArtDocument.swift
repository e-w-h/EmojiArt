//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/16/20.
//

import SwiftUI
import Combine // Framework for cancellable, publishing, subscribing

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️🌧🍎"
    
    // Published so that whenever something changes the ObservableObject can redraw
    // Private because viewmodel interprets the view
    @Published private var emojiArt: EmojiArt
    
    // Guarantees that the key is the same in all instances
    private static let untitled = "EmojiArtDocument.Untitled"
    
    private var autoSaveCancellable: AnyCancellable?
    
    init() {
        // If it returns nil we create a blank document
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        // Use binding to update the publisher causing an auto save every time something changes
        // Never completes so never fails. Use simple version of sink with receiveValue
        autoSaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
    // Published so view changes when viewmodel changes
    // Private so only the viewmodel fetches the image (not the view)
    // UIImage is different than an Image struct
    // Optional because we might not have the image
    @Published private(set) var backgroundImage: UIImage?
    
    // Provide read only access to model
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    // View cant access the model directly so it calls intent functions
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.width)
        }
        
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {

    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        // Clear the background image while the app searches the internet for the image
        backgroundImage = nil
        // if let means the app is only fetching if there is a URL to search for
        if let url = emojiArt.backgroundURL {
            // Cancel previous background image data before fetching the new one
            fetchImageCancellable?.cancel()
            let session = URLSession.shared // static var for simple downloads
            // Tease the publisher to do what you want
            let publisher = session.dataTaskPublisher(for: url)
                // map'ed into a different publisher so that it publishes uiimage
                // Publishes it on the background thread by default
                .map { data, URLResponse in UIImage(data: data) }
                // Change it to the main queue
                .receive(on: DispatchQueue.main)
                // Change publisher to error type to never to use assign
                .replaceError(with: nil)
            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self) // EmojiArtDocument is inferred
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
