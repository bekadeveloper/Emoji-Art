//
//  ContentView.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map({ String($0) }), id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            
            Color.white
                .edgesIgnoringSafeArea(.bottom)
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    drop(providers)
                }
        }
    }
    
    private func drop(_ providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            viewModel.setBackground(url)
            print("dropped: \(url)")
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
