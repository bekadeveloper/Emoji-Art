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
        
        fileprivate init(_ text: String, x: Int, y: Int, size: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        emojis.append(Emoji(text, x: x, y: y, size: size))
    }
}
