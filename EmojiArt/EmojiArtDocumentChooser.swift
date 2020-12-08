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
        // Encapsulates the list view with a header space for a title
        // Title can be set on each view within the navigation
        NavigationView {
            // List is a powerful VStack with a vertical scroll
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document).navigationBarTitle(self.store.name(for: document))) {
                        Text(self.store.name(for: document))
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(leading: Button(action: { self.store.addDocument() }, label: {
                Image(systemName: "plus").imageScale(.large)
                
            }))
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
