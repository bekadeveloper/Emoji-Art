//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Begzod on 21/05/21.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var viewModel: EmojiArtDocument
    @Binding var chosenPalette: String
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: { chosenPalette = viewModel.palette(after: chosenPalette) },
                onDecrement: { chosenPalette = viewModel.palette(before: chosenPalette) },
                label: { EmptyView() })
            Text(viewModel.paletteNames[chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
