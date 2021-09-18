//
//  Theme.swift
//  Memorize
//
//  Created by Ilya Zavidny on 16.09.2021.
//

import Foundation
import SwiftUI


struct Theme<Item> {
    let name: String
    let items: [Item]
    private var pairFunc: () -> Int
    var pairsToShow: Int { pairFunc() }
    let color: Color
    
    init(named n: String, withItems i: [Item], colored c: Color) {
        name = n
        items = i
        pairFunc = { i.count }
        color = c
    }
    
    init(named n: String, withItems i: [Item], limitedPairs p: Int, colored c: Color) {
        self.init(named: n, withItems: i, colored: c)
        pairFunc = { p }
    }
    
    init(named n: String, withItems i: [Item], colored c: Color, randomized: Bool) {
        self.init(named: n, withItems: i, colored: c)
        pairFunc = { Int.random(in: 4..<i.count) }
    }
}
