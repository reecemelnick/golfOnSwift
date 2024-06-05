//
//  EditProfileView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-25.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newUsername: String = ""
    @Binding var isPresented: Bool
    var usernameChanged: (String) -> Void

    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.title)
                .fontWeight(.bold)
            TextField("New Username", text: $newUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                dataManager.changeUsername(newUsername: newUsername)
                usernameChanged(newUsername)
                isPresented = false
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}


struct prevView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(isPresented: .constant(true)) { newUsername in
            // This closure can be empty for preview purposes
        }
    }

}

