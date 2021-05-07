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
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(EmojiArtDocument.palette.map({ String($0) }), id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                
                Button(action: viewModel.clearDocument) {
                    Text("Clear")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .overlay(
                            OptionalImage(uiImage: viewModel.backgroundImage)
                                .scaleEffect(zoomScale)
                        )
                        .onTapGesture(count: 2) {
                            withAnimation {
                                zoomToFit(viewModel.backgroundImage, in: geometry.size)
                            }
                        }
                    
                    ForEach(viewModel.emojis) { emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * zoomScale)
                            .position(position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    
                    // MARK:    Why we need to change coordinate system... no idea...
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    
                    return drop(providers, at: location)
                }
            }
        }
    }
    
    @State private var zoomScale: CGFloat = 1
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        guard image != nil else { return }
        guard image!.size.width > 0, image!.size.height > 0 else { return }
        
        let hZoom = size.width / image!.size.width
        let vZoom = size.height / image!.size.height
        zoomScale = min(hZoom, vZoom)
        
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        // MARK:    Why we need to change coordinate system... no idea...
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        
        return location
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



