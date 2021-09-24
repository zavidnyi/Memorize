//
//  ThemeManager.swift
//  Memorize
//
//  Created by Ilya Zavidny on 24.09.2021.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var themeStore: ThemeStore
        
    @State private var editMode: EditMode = .active
    
    @State private var themeToEdit: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.themes) { theme in
                    themeDescription(of: theme)
                }
                .onDelete{ indexSet in
                    themeStore.themes.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    themeStore.themes.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    addTheme
                }
            }
            .popover(item: $themeToEdit, content: { theme in
                ThemeEditor(theme: $themeStore.themes[themeStore.themes.firstIndex(where: { $0.id == theme.id })!])
            })
            .environment(\.editMode, $editMode)
        }
    }
    
    func themeDescription(of theme: Theme) -> some View {
        NavigationLink ( destination: EmojiMemoryGameView(game: EmojiMemoryGame(themed: theme))) {
            VStack(alignment: .leading) {
                Text(theme.name.capitalized).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(Color(rgbaColor: theme.color))
                Text(theme.items.joined())
            }
            .gesture(editMode == .active ? editTap(of: theme) : nil)
        }
    }
    
    var addTheme: some View {
        Button {
            themeStore.addTheme(named: "New", withItems: [], withPlayablePairs: 0, colored: .black)
            themeToEdit = themeStore.themes.last
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func editTap(of theme: Theme) -> some Gesture {
        TapGesture (count: 1)
            .onEnded {
                themeToEdit = theme
            }
    }
}




struct ThemeManager_Previews: PreviewProvider {
    @StateObject static var themeStore = ThemeStore(named: "Preview")
    static var previews: some View {
        ThemeManager()
            .environmentObject(themeStore)
    }
}
