//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palette = "🚴🏻‍♂️🤺📔🗻🪂🏂🃏👨🏻‍💻📚"
    
    @Published private var model: EmojiArt = EmojiArt()
    
    
    // MARK: - Intents
    
    func addEmoji(_ text: String, at location: CGPoint, size: CGFloat) {
        model.addEmoji(text, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        guard let index = model.emojis.firstIndex(where: { emoji.id == $0.id }) else { return }
        
        model.emojis[index].x += Int(offset.width)
        model.emojis[index].y += Int(offset.height)
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        guard let index = model.emojis.firstIndex(where: { emoji.id == $0.id }) else { return }
        
        model.emojis[index].size = Int((CGFloat(model.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
    
    func setBackground(_ url: URL?) {
        model.backgroundURL = url?.imageURL
    }
}
