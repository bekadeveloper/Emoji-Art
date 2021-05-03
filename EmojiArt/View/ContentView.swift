//
//  ContentView.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map({ String($0) }), id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.bottom)
                        .overlay(
                            Group {
                                if let uiImage = viewModel.backgroundImage {
                                    Image(uiImage: uiImage)
                                }
                            }
                        )
                        .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                            let location = geometry.convert(location, from: .global)
                            
                            // MARK:    Why we need to change coordinate system... no idea...
//                            location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                            
                            return drop(providers, at: location)
                        }
                        
                    
                    ForEach(viewModel.emojis) { emoji in
                        Text(emoji.text)
                            .font(font(for: emoji))
                            .position(emoji.location)
                    }
                }
            }
        }
    }
    
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        
        // MARK:    Why we need to change coordinate system... no idea...
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    private func drop(_ providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            viewModel.setBackground(url)
            print("dropped: \(url)")
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                viewModel.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiArtDocument())
    }
}
