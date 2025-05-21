//
//  Redesign_YoohooApp.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 09/05/25.
//

import SwiftUI

@main
struct YoohooApp: App {
    @State private var openForm = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListFriendView()
                    .navigationDestination(isPresented: $openForm) {
                        FormView()
                    }
                    .onOpenURL { url in
                        if url.scheme == "yoohoo", url.host == "add-friend-form" {
                            openForm = true
                        }
                    }
            }
        }
        .modelContainer(for: [Buddy.self])
    }
}


//
//import SwiftUI
//
//@main
//struct YoohooApp: App {
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                ListFriendView()
//            }
//            .modelContainer(for: [Buddy.self])
//        }
//    }
//}

