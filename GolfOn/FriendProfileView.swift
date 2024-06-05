//
//  FriendProfileView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-24.
//

import SwiftUI
import FirebaseAuth

struct FriendProfileView: View {
    let friend: User
    @EnvironmentObject var dataManager: DataManager
    @State private var showAlert = false
    
    
    var body: some View {
            ScrollView {
                VStack {
                    Image("def-pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .padding(22)
                    HStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                            .frame(width: 180, height: 50)
                            .overlay(
                                Text(friend.username)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        Button(action: {
                            if let currentUser = Auth.auth().currentUser {
                                    dataManager.removeFriend(userEmail: currentUser.email ?? "", friendUsername: friend.username)
                                } else {
                                    print("No user is currently signed in")
                                }
                            showAlert = true
                        }, label: {
                            Text("Remove Friend")
                                .bold()
                                .frame(width: 140, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Friend Removed"),
                                  message: Text("Your friend has been removed successfully!"),
                                  dismissButton: .default(Text("OK")))
                        }
                    }
                }
            }
        
    }
}

#Preview {
    FriendProfileView(friend: User(id: 1, fullname: "John Doe", username: "john_doe", email: "john@example.com", friends: []))
}

