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
        }
    }
    private let defaultEmojiSize: CGFloat = 40
}
