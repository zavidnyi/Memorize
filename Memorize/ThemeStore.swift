//
//  Theme.swift
//  Memorize
//
//  Created by Ilya Zavidny on 16.09.2021.
//

import Foundation
import SwiftUI


struct Theme: Codable, Identifiable {
    var name: String
    var items: [String]
    var pairsToShow: Int
    var color: RGBAColor
    var cColor: Color {
        get { Color(rgbaColor: color) }
        set { color = RGBAColor(color: newValue)}
    }
    let id: Int
    
    private static var uniqueId = 0
    
    fileprivate init(named name: String, withItems items: [String], colored color: RGBAColor) {
        self.name = name
        self.items = items
        pairsToShow = items.count
        self.color = color
        id = Theme.uniqueId
        Theme.uniqueId += 1
    }
}

class ThemeStore: ObservableObject{
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String { "ThemeStore:" + name }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedPalettes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedPalettes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            addTheme(named: "cars", withItems: ["🚙", "🚜", "✈️", "🚀", "🚗", "🚠", "🚂", "🛶", "🚒", "🛳", "🏍", "🛴", "🛵", "🚔", "🛺"], withPlayablePairs: 6, colored: .blue)
            addTheme(named: "food", withItems: ["🍏", "🥐", "🌭", "🍞", "🥗", "🥘", "🍆", "🍔", "🍙", "🍰", "🧃"], withPlayablePairs: 6, colored: .green)
            addTheme(named: "flags", withItems: ["🏴‍☠️", "🇬🇧" ,"🇳🇴", "🇷🇺", "🇲🇰", "🇼🇸", "🇺🇸" ,"🇵🇭", "🇨🇿", "🇫🇷", "🇯🇵"], withPlayablePairs: 6, colored: .red)
            addTheme(named: "animals", withItems: ["🐶", "🦊", "🐻", "🐵", "🐨", "🦁", "🐯", "🐷", "🐸", "🐤", "🐗"], withPlayablePairs: 6, colored: .orange)
            addTheme(named: "zodiacs", withItems: ["♈️", "♉️" ,"♊️", "♋️", "♌️", "♍️", "♎️" ,"♏️", "♐️", "♒️", "♓️"], withPlayablePairs: 6, colored: .yellow)
            addTheme(named: "tech", withItems: ["⌚️", "📱" ,"💻", "🖥", "🖨", "☎️", "📺" ,"🎥"], withPlayablePairs: 6, colored: .gray)
            
        }
    }
    
    // MARK: - Intents
    
    func addTheme(named name: String, withItems items: [String], withPlayablePairs pairs: Int, colored color: Color) {
        themes.append(Theme(named: name, withItems: items, colored: RGBAColor(color: color)))
    }

}
