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
    @Binding var showingPaletteEditor: Bool
    @State var chosenPaletteName: String
    @State private var emojisToAdd: String = ""
    
    private static var gridItems = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline)
                HStack {
                    Spacer()
                    Button(action: { showingPaletteEditor.toggle() }) {
                        Text("Done")
                    }
                }
            }
            .padding()
            Divider()
            
            Form {
                Section {
                    TextField("Name", text: $chosenPaletteName, onEditingChanged: { began in
                        if !began {
                            viewModel.renamePalette(chosenPalette, to: chosenPaletteName)
                        }
                    })
                    
                    TextField("Add emoji", text :$emojisToAdd, onEditingChanged: { _ in
                        chosenPalette = viewModel.addEmoji(emojisToAdd, toPalette: chosenPalette)
                    })
                }
                
                Section(header: Text("Remove emoji")) {
                    LazyVGrid(columns: PaletteEditor.gridItems) {
                        ForEach(chosenPalette.map({ "\($0)" }), id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 40))
                                .padding(5)
                                .onTapGesture {
                                    chosenPalette = viewModel.removeEmoji(emoji, fromPalette: chosenPalette)
                                }
                        }
                    }
                }
            }
        }
    }
}
