//
//  ContentView.swift
//  EmojiArt
//
//  Created by Begzod on 03/05/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiArtDocument
    @State private var chosenPalette: String = ""
    @State private var explainBackgroundPaste: Bool = false
    @State private var confirmBackgroundPaste: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(chosenPalette: $chosenPalette)
                    .environmentObject(viewModel)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map({ "\($0)" }), id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                .onAppear { chosenPalette = viewModel.defaultPalette }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .overlay(
                            OptionalImage(uiImage: viewModel.backgroundImage)
                                .scaleEffect(zoomScale)
                                .offset(panOffset)
                        )
                        .gesture(doubleTapToZoom(in: geometry.size))
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        ForEach(viewModel.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(zoomGesture())
                .gesture(panGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(viewModel.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    
                    // MARK:    Why we need to change coordinate system... no idea...
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    
                    return drop(providers, at: location)
                }
                .alert(isPresented: $confirmBackgroundPaste) {
                    Alert(title: Text("Paste Background"),
                          message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?"),
                          primaryButton: .default(Text("OK")) {
                            viewModel.backgroundURL = UIPasteboard.general.url
                          },
                          secondaryButton: .cancel())
                }
            }
            .zIndex(-1)
        }
        .navigationBarItems(trailing:
                                Button(action: {
                                    if let url = UIPasteboard.general.url, url != viewModel.backgroundURL {
                                        confirmBackgroundPaste.toggle()
                                    } else {
                                        explainBackgroundPaste.toggle()
                                    }}) {
                                        Image(systemName: "doc.on.clipboard")
                                            .alert(isPresented: $explainBackgroundPaste) {
                                                Alert(title: Text("Paste Background"),
                                                      message: Text("Copy the URL of an image to the clipboard and tap this button to make it the background of your document."),
                                                      dismissButton: .default(Text("OK"))
                                                )
                                            }
                                    }
        )
    }
    
    private var isLoading: Bool {
        return viewModel.backgroundURL != nil && viewModel.backgroundImage == nil
    }
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        return viewModel.steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                viewModel.steadyStateZoomScale *= finalGestureScale
            }
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        return (viewModel.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                viewModel.steadyStatePanOffset = viewModel.steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(viewModel.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            viewModel.steadyStatePanOffset = .zero
            viewModel.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        // MARK:    Why we need to change coordinate system... no idea...
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        
        return location
    }
    
    private func drop(_ providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            viewModel.backgroundURL = url
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
