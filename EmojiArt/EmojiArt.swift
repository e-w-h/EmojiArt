//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/18/20.
//

import Foundation

struct EmojiArt {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    // Want to use ForEach so we add Identifiable
    struct Emoji: Identifiable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        // Privately managed public variable
        let id: Int
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
