//
//  GolfOnApp.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-06.
//

import SwiftUI
import Firebase

@main
struct GolfOnApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }

    }
}
