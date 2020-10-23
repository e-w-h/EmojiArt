//
//  EmojiArtExtensions.swift
//  EmojiArt
//
//  Created by Eric Hou on 10/22/20.
//

import SwiftUI

extension Collection where Element: Identifiable {
    func firstIndex(matching element: Element) -> Index? {
        firstIndex(where: {$0.id == element.id })
    }
    func contains(matching element: Element) -> Bool {
        contains(where: {$0.id == element.id })
    }
}

