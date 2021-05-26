//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Begzod on 21/05/21.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var viewModel: EmojiArtDocument
    @Binding var chosenPalette: String
    @State private var showingPaletteEditor: Bool = false
    @State private var chosenPaletteName: String = ""
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: { chosenPalette = viewModel.palette(after: chosenPalette) },
                onDecrement: { chosenPalette = viewModel.palette(before: chosenPalette) },
                label: { EmptyView() }
            )
            
            Text(chosenPaletteName)
            
            Button(action: { showingPaletteEditor.toggle() }) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
            .sheet(isPresented: $showingPaletteEditor) {
                PaletteEditor(chosenPalette: $chosenPalette, showingPaletteEditor: $showingPaletteEditor, chosenPaletteName: $chosenPaletteName)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .onChange(of: chosenPalette) { _ in
            chosenPaletteName = viewModel.paletteNames[chosenPalette] ?? ""
        }
    }
}
