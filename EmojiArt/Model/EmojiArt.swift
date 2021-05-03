//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import Foundation

struct EmojiArt {
    
    var backgroundURL: URL?
    
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable {
        var id = UUID()
        let text: String
        var x: Int
        var y: Int
        var size: Int
    }
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        emojis.append(Emoji(text: text, x: x, y: y, size: size))
    }
}
