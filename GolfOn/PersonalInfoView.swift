//
//  PersonalInfoView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-12.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct PersonalInfoView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State var filledOut = false
    @State private var fullname = ""
    @State private var username = ""
    @State private var userEmail = ""
    @Binding var newUser: Bool

    
    var body: some View {
        VStack {
            Spacer()
            Text("Email: \(userEmail)")
                .padding()
                .onAppear {
                if let user = Auth.auth().currentUser {
                    userEmail = user.email ?? "No email found"
                    } else {
                        userEmail = "No user logged in"
                    }
                }
            NavigationView {
                Form {
                    TextField("Full Name", text: $fullname)
                    TextField("Username", text: $username)
                }
                .navigationTitle("Profile Details")
            }
            Button(action: {
                dataManager.addUser(email: userEmail, fullname: fullname, username: username)
                newUser = false
                    presentationMode.wrappedValue.dismiss()
                
                
            }, label: {
                Text("Save")
                    .bold()
                    .frame(width: 100, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            })
            .offset(y: -400)
        }
    }
    
}

struct PersonalInfoView_Previews: PreviewProvider {
    @State static var newUser = true // Create a State variable to mimic newUser
    
    static var previews: some View {
        PersonalInfoView(newUser: $newUser)
            .environmentObject(DataManager()) // Ensure DataManager is available
    }
}

