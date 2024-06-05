//
//  ProfileView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-12.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    @State private var fullName: String?
    @State private var userName: String?
    @EnvironmentObject var dataManager: DataManager
    @State private var currentUserEmail: String?
    @State private var userIsLoggedIn = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView{
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
                                Text(userName ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        Button(action: {
                        }, label: {
                            Text("Share")
                                .bold()
                                .frame(width: 75, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                        })
                        Button(action: {
                            _ = EditProfileView(isPresented: $isEditingProfile) { newUsername in
                                self.userName = newUsername
                            }
                            isEditingProfile = true
                        }, label: {
                            Text("Edit")
                                .bold()
                                .frame(width: 75, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                        })
                    }
                    .padding()
                    Rectangle()
                        .frame(width: 360, height: 3)
                    HStack {
                        Button(action: {
                        }, label: {
                            Text("Recents Matches")
                                .bold()
                                .frame(width: 180, height: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                                .font(.title)
                        })
                        .padding(.top, 20)
                        NavigationLink(destination: FriendsView()) {
                            Text("My Friends")
                                .bold()
                                .frame(width: 180, height: 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        .padding(.top, 20)

                    }
                    Button(action: {
                        logout()
                    }, label: {
                        Text("Logout")
                            .bold()
                            .frame(width: 360, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                    })
                    .padding(.top, 35)
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear {
            //print(dataManager.users)
            print(dataManager.userFriends)
            updateCurrentUserEmail()
            printCurrentUserEmail()
            userName = dataManager.getCurrentUsername()
        }
        .sheet(isPresented: $isEditingProfile) {
            EditProfileView(isPresented: $isEditingProfile, usernameChanged: { newUsername in
                self.userName = newUsername
            }) // Pass binding and
        }

    }
    
    func logout() {
            do {
                try Auth.auth().signOut()
                userIsLoggedIn.toggle()
                presentationMode.wrappedValue.dismiss()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    
    
    // Update currentUserEmail state with the current user's email
        private func updateCurrentUserEmail() {
            if let currentUser = Auth.auth().currentUser {
                currentUserEmail = currentUser.email
            } else {
                currentUserEmail = nil
            }
        }

        // Print the current user's email
        private func printCurrentUserEmail() {
            if let email = currentUserEmail {
                print("Current User Email: \(email)")
            } else {
                print("No user signed in")
            }
        }
    }


#Preview {
    ProfileView()
        .environmentObject(DataManager())
}
