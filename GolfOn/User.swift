//
//  User.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-10.
//

import SwiftUI
import Firebase

struct User: Identifiable {
    var id: Int
    var fullname: String
    var username: String
    var email: String
    var friends: [User]
}

