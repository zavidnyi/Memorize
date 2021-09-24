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
    
    mutating func shuffle() {
        cards.shuffle()
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
        var isFaceUp = false {
            didSet {
                isFaceUp ?  startUsingBonusTime() : stopUsingBonusTime()
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var wasSeen = false
        var content: CardContent
        var id: Int
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}


extension Array {
    var oneAndOnly: Element? {
        count == 1 ? first: nil
    }
}
