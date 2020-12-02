//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Eric Hou on 11/26/20.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            // Initialization process
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
                }
                // Generally an iPad feature due to the large space
                // On an iPhone a popover uses the entire screen
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: self.$chosenPalette)
                        // For the environment object in the palette editor struct
                        .environmentObject(self.document)
                        // Set a minimum size for the view
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    // Pass the view model to a separate view using an environment object
    @EnvironmentObject var document: EmojiArtDocument
    
    // Two bindings should have the same name so we know theyre bound
    @Binding var chosenPalette: String
    
    @State private var paletteName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Palette Editor").font(.headline).padding()
            Divider()
            TextField("Palette Name", text: $paletteName)
                .padding()
            // Moves the text to the top
            Spacer()
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
