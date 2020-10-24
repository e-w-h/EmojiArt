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

extension URL {
    var imageURL: URL {
        for query in query?.components(separatedBy: "&") ?? [] {
            let queryComponents = query.components(separatedBy: "=")
            if queryComponents.count == 2 {
                if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                    return url
                }
            }
        }
        return self.baseURL ?? self
    }
}
