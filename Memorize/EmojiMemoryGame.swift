//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ilya Zavidny on 15.09.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let themes = [
        Theme<String>(named: "cars", withItems: ["🚙", "🚜", "✈️", "🚀", "🚗", "🚠", "🚂", "🛶", "🚒", "🛳", "🏍", "🛴", "🛵", "🚔", "🛺"], colored: .blue, randomized: true),
        Theme<String>(named: "food", withItems: ["🍏", "🥐", "🌭", "🍞", "🥗", "🥘", "🍆", "🍔", "🍙", "🍰", "🧃"], colored: .green, randomized: true),
        Theme<String>(named: "flags", withItems: ["🏴‍☠️", "🇬🇧" ,"🇳🇴", "🇷🇺", "🇲🇰", "🇼🇸", "🇺🇸" ,"🇵🇭", "🇨🇿", "🇫🇷", "🇯🇵"], colored: .red, randomized: true),
        Theme<String>(named: "animals", withItems: ["🐶", "🦊", "🐻", "🐵", "🐨", "🦁", "🐯", "🐷", "🐸", "🐤", "🐗"], colored: .orange, randomized: true),
        Theme<String>(named: "zodiacs", withItems: ["♈️", "♉️" ,"♊️", "♋️", "♌️", "♍️", "♎️" ,"♏️", "♐️", "♒️", "♓️"], colored: .yellow, randomized: true),
        Theme<String>(named: "tech", withItems: ["⌚️", "📱" ,"💻", "🖥", "🖨", "☎️", "📺" ,"🎥"], colored: .gray, randomized: true)
    ]
    
    private(set) var theme: Theme<String>
    static func createMemoryGame(withTheme theme: Theme<String>) -> MemoryGame<String> {
        let shuffledItems = theme.items.shuffled()
        return MemoryGame<String>(numberOfPairs: min(theme.items.count, theme.pairsToShow)) { index in
            shuffledItems[index]
        }
    }
    
    @Published private var model: MemoryGame<String>
    
    init() {
        theme = EmojiMemoryGame.themes[Int.random(in: 0..<EmojiMemoryGame.themes.count)]
        model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
    }
    
    var cards: Array<Card> { model.cards }
    
    var score: Int { model.score }
    
    // MARK: - Intent (s)
    
    func choose( _ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = EmojiMemoryGame.themes[Int.random(in: 0..<EmojiMemoryGame.themes.count)]
        model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
    }
}
