//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Eric Hou on 12/7/20.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    // Common to use environment object for a top level view
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    var body: some View {
        // List is a powerful VStack
        List {
            ForEach(store.documents) { document in
                Text(self.store.name(for: document))
            }
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
