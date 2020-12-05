//
//  Grid.swift
//  Memorize
//
//  Created by Eric Hou on 10/4/20.
//

import SwiftUI

// Advanced constrains and gains
extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItem: viewForItem)
    }
}

// Using protocols to constrain generics
struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    // Public initializer initializes them
    private var items: [Item]
    private var id: KeyPath<Item, ID>
    private var viewForItem: (Item) -> ItemView
    
    // Detect and avoid memory cycles with the @escaping
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        // Figure out how much space has been allocated with the view
        GeometryReader { geometry in
            // GeometryReader is escaping so we need self.body
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    // func so we can access self thats within scope
    private func body(for layout: GridLayout) -> some View {
        ForEach(items, id: id) { item in
            // ForEach is escaping so we need self.body
            self.body(for: item, in: layout)
        }
    }
    
    // func so we dont need self
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] } )
        return Group {
            if index != nil {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
            }
        }
    }
}
