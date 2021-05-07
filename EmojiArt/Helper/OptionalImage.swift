//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Begzod on 07/05/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
