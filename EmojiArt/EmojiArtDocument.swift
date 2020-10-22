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
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        
    }
}
