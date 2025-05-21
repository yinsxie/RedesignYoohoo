//
//  ShortcutProvider.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 18/05/25.
//

import AppIntents

struct AppShortcutProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddFriendIntent(),
            phrases: ["Tambah teman di \(.applicationName)"],
            shortTitle: "Tambah Teman",
            systemImageName: "person.badge.plus"
        )
    }
}
