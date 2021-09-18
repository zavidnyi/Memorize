//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Ilya Zavidny on 13.09.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
