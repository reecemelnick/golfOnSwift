//
//  NewNavBar.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-11.
//

import SwiftUI

struct NewNavBar: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "house")
                }
            UserView()
                .tabItem {
                    Image(systemName: "leaf")
                }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.green)
        .environmentObject(DataManager())
        
    }
}

#Preview {
    NewNavBar()
        //.environmentObject(DataManager())
}
