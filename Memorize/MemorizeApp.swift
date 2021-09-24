//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Ilya Zavidny on 13.09.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            ThemeManager()
                .environmentObject(themeStore)
        }
    }
}
