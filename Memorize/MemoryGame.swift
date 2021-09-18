//
//  MemoryGame.swift
//  Memorize
//
//  Created by Ilya Zavidny on 15.09.2021.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private(set) var score: Int
    
    private var faceUpIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }

    }
    mutating func choose (_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }), !cards[index].isFaceUp, !cards[index].isMatched {
            if let potentialMatch = faceUpIndex {
                if cards[index].content == cards[potentialMatch].content {
                    cards[index].isMatched = true
                    cards[potentialMatch].isMatched = true
                    score += 2
                } else {
                    cards[index].wasSeen ? score -= 1 : cards[index].wasSeen.toggle()
                    cards[potentialMatch].wasSeen ? score -= 1 : cards[potentialMatch].wasSeen.toggle()
                }
                cards[index].isFaceUp = true
            } else {
                faceUpIndex = index
            }
        }
    }
    
    init (numberOfPairs: Int, createCardContent: (Int) -> CardContent) {
        score = 0
        cards = []
        for pair in 0..<numberOfPairs {
            let content = createCardContent(pair)
            cards.append(Card(content: content, id: pair*2))
            cards.append(Card(content: content, id: pair*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var wasSeen = false
        var content: CardContent
        var id: Int
    }
}


extension Array {
    var oneAndOnly: Element? {
        count == 1 ? first: nil
    }
}
