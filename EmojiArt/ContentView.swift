//
//  ContentView.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/16/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
