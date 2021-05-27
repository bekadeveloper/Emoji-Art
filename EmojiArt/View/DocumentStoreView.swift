//
//  DocumentStoreView.swift
//  EmojiArt
//
//  Created by Begzod on 26/05/21.
//

import SwiftUI

struct DocumentStoreView: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: ContentView(viewModel: document).navigationBarTitle(Text(store.name(for: document)))) {
                        EditableText(store.name(for: document), isEditing: editMode.isEditing) { name in
                            store.setName(name, for: document)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.documents[$0] }.forEach { document in
                        store.removeDocument(document)
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
            .environment(\.editMode, $editMode)
        }
    }
}
