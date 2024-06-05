//
//  ListView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-07.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    @State private var userIsLoggedIn = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false


    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("Golf Courses")) {
                        ForEach(dataManager.Courses, id: \.id) { course in
                            Text(course.city)
                        }
                    }
                                    
                    Section(header: Text("Users")) {
                        ForEach(dataManager.users.filter { user in
                            !dataManager.userFriends.contains { $0.username == user.username }
                        }, id: \.id) { user in
                            HStack {
                                Text(user.username)
                                Spacer()
                                Button(action: {
                                    let (user, email) = getUserByEmail(username: user.username)

                                    if let user = user, let email = email {
                                        // User and email found
                                        print("User: \(user.fullname), Email: \(email)")
                                        dataManager.addFriend(userEmail: email, friend: user)
                                        showAlert = true
                                    } else {
                                        // User not found
                                        print("User not found")
                                    }
                                }) {
                                    Image(systemName: "person.badge.plus") // Add an image for the button
                                }
                                .buttonStyle(PlainButtonStyle()) // Apply the custom button style
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Friend Added"),
                                          message: Text("Your friend has been added successfully!"),
                                          dismissButton: .default(Text("OK")))
                                }
                            }
                        }
                    }

                }
                .navigationTitle("Search")
                .navigationBarItems(trailing: Button(action: {
                    showPopup.toggle()
                }, label: {
                Image(systemName: "plus")
                }))
                .sheet(isPresented: $showPopup) {
                    NewCourseView()
                }
            }
    }
    
    func getUserByEmail(username: String) -> (User?, String?) {
        for user in dataManager.users {
            if user.username == username {
                // If the username matches, return the user instance and the email
                return (user, user.email)
            }
        }
        // If no user with the given username is found, return nil for both user instance and email
        return (nil, nil)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataManager())
    }
}


