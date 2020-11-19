//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Eric Hou on 11/19/20.
//

import SwiftUI

// Utility that handles a uiImage that might be nil
struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        // Group is useful for passing a view with an if statement
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
