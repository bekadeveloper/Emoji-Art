//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Begzod on 24/05/21.
//

import SwiftUI

struct PaletteEditor: View {
    @EnvironmentObject var viewModel: EmojiArtDocument
    @Binding var chosenPalette: String
    @State var chosenPaletteName: String
    @State private var emoji: String = ""
    
    var body: some View {
        Group {
            Form {
                Section(header: Text("Rename palette")) {
                    TextField("Name", text: $chosenPaletteName) { _ in viewModel.renamePalette(chosenPalette, to: chosenPaletteName) }
                }
                Section(header: Text("Add emoji")) {
                    TextField("Add", text: $emoji) { _ in
                                chosenPalette = viewModel.addEmoji(emoji, toPalette: chosenPalette)}
                }
                Section(header: Text("Remove emoji")) {
                    HStack {
                        ForEach(chosenPalette.map({ "\($0)" }), id: \.self) { emoji in
                            Text(emoji)
                                .onTapGesture {
                                    chosenPalette = viewModel.removeEmoji(emoji, fromPalette: chosenPalette)
                                }
                        }
                    }
                }
            }
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}
