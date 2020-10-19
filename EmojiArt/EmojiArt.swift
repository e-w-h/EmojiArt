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
        
        // In case someone wants to creates an emoji and sets the id themselves
        // The custom init has all the standard boiler you get from a free init
        // Making it private nobody can create an emoji besides Emoji
        // File private makes the function private in the file and lets EmojiArt use the addEmoji func
        fileprivate init(text: String, x : Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}