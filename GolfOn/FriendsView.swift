//
//  FriendsView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct FriendsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedFriend: User? = nil
    
    var body: some View {
            List {
                ForEach(dataManager.userFriends, id: \.id) { user in
                    HStack {
                        Button(action: {
                            self.selectedFriend = user
                        }) {
                            Text(user.username)
                        }
                    }
                }
            }
            .navigationTitle("Friends")
            .sheet(item: $selectedFriend) { friend in
                FriendProfileView(friend: friend)
            }
        }
    
    


}

#Preview {
    FriendsView()
        .environmentObject(DataManager())
        
}
