//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: EmojiArtDocument())
        }
    }
}
