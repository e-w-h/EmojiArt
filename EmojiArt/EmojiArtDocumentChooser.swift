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
    
    @State private var editMode: EditMode = .inactive  // Active, inactive or transient
    
    var body: some View {
        // Encapsulates the list view with a header space for a title
        // Title can be set on each view within the navigation
        NavigationView {
            // List is a powerful VStack with a vertical scroll
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document).navigationBarTitle(store.name(for: document))) {
                        EditableText(store.name(for: document), isEditing: editMode.isEditing) { name in
                            store.setName(name, for: document)
                        }
                    }
                }
                // Swipe to delete
                // For all the things in an index set remove the documents
                // Coding style is advanced in swift but widely used
                .onDelete { indexSet in
                    indexSet.map { store.documents[$0] }.forEach { document in
                        store.removeDocument(document)
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(
                leading: Button(action: {
                    store.addDocument()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                
                }),
                // Button to go into edit mode
                trailing: EditButton()
            )
            // Set Environment for view we're calling it on
            // View must have the edit button which is why this code is below the button
            .environment(\.editMode, $editMode)
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
