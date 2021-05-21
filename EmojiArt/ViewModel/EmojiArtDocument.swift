//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
    static let palette = "🚴🏻‍♂️🤺📔🗻🪂🏂🃏👨🏻‍💻📚"
    
    
    // MARK: - Acces to the model
    @Published private var model: EmojiArt
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        model = EmojiArt(json: UserDefaults.standard.data(forKey: "EmojiArtDocument.Untitled")) ?? EmojiArt()
        autosaveCancellable = $model.sink { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: "EmojiArtDocument.Untitled")
        }
        fetchBackgroundImage()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { model.emojis }
    
    
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
    
    var backgroundURL: URL? {
        get {
            model.backgroundURL
        }
        set {
            model.backgroundURL = newValue?.imageURL
            fetchBackgroundImage()
        }
    }
    
    
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImage() {
        backgroundImage = nil
        guard let url = model.backgroundURL else { return }
        
        fetchImageCancellable?.cancel()
        fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, urlResponse in UIImage(data: data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.backgroundImage, on: self)
    }
    
    func clearDocument() {
        model = EmojiArt()
        backgroundImage = nil
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(self.x), y: CGFloat(self.y)) }
}

