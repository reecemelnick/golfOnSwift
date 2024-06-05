//
//  UserView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-10.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack {
            NavigationView {
                List(dataManager.users, id: \.id) { user in
                    Text(user.email)
                }
                .navigationTitle("Users")
            }
            Spacer()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(DataManager())
    }
}
