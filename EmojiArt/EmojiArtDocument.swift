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
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    // MARK: Multithreading
    
    private func fetchBackgroundImageData() {
        // Clear the background image while the app searches the internet for the image
        backgroundImage = nil
        // if let means the app is only fetching if there is a URL to search for
        if let url = emojiArt.backgroundURL {
            // Data can take a long time to load and we dont want it on the main thread
            // The if let is still blocking but on a backgrouund queue
            DispatchQueue.global(qos: .userInitiated).async {
                // Fetching on the interent can run into a lot of errors that we need "try" to deal with
                if let imageData = try? Data(contentsOf: url) {
                    // Drawing always has to happen on the main thread
                    // Posting asynchronously causes the queue to run
                    DispatchQueue.main.async {
                        // Confirm that the url of the image were loading is the same as the one that the user most recently dragged and dropped
                        // Very important concept to protect against unknown variables like server response time
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }

        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
