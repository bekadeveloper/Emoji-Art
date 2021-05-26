//
//  DocumentStoreView.swift
//  EmojiArt
//
//  Created by Begzod on 26/05/21.
//

import SwiftUI

struct DocumentStoreView: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: ContentView(viewModel: document).navigationBarTitle(Text(store.name(for: document)))) {
                        Text(store.name(for: document))
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitle(Text(store.name))
            .navigationBarItems(leading:
                                    Button(action: { store.addDocument() }) {
                                        Image(systemName: "plus.circle.fill")
                                    },
                                trailing: EditButton()
            )
        }
    }
}
