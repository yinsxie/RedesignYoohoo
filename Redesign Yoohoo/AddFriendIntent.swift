//
//  AddFriendIntent.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 18/05/25.
//

import AppIntents
import UIKit

struct AddFriendIntent: AppIntent {
    static var title: LocalizedStringResource = "Tambah Teman"

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            if let url = URL(string: "yoohoo://add-friend-form") {
                UIApplication.shared.open(url)
            }
        }
        // Delay supaya iOS punya waktu buka aplikasi
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 detik
        return .result()
    }
}


