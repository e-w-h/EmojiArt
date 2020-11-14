//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/16/20.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️🌧🍎"
    
    // Published so that whenever something changes the ObservableObject can redraw
    // Private because viewmodel interprets the view
    @Published private var emojiArt: EmojiArt = EmojiArt()
    
    // Published so view changes when viewmodel changes
    // Private so only the viewmodel fetches the image (not the view)
    // UIImage is different than an Image struct
    // Optional because we might not have the image
    @Published private(set) var backgroundImage: UIImage?
    
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
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
    }
}
