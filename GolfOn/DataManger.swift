//
//  DataManger.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-07.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class DataManager: ObservableObject {
    @Published var Courses: [GolfCourse] = []
    @Published var users: [User] = []
    @Published var userFriends: [User] = []
        
    init() {
        fetchCourses()
        fetchUserData()
        displayFriendsList { friends in
                // Update userFriends array with fetched friends
                self.userFriends = friends
            }
    }
    
    // Function to fetch and display friends
    func displayFriendsList(completion: @escaping ([User]) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently signed in")
            completion([])
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")

        // Query for the user document based on their email
        let userQuery = usersCollection.whereField("email", isEqualTo: currentUser.email ?? "")

        userQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                completion([])
            } else {
                if let document = querySnapshot?.documents.first {
                    let friendsArray = document.data()["friends"] as? [[String: Any]] ?? []

                    // Create an array to store the fetched friends
                    var friendsList: [User] = []

                    // Iterate through the friends array and fetch the id and username of each friend
                    for friendData in friendsArray {
                        if let friendID = friendData["id"] as? Int,
                           let friendUsername = friendData["username"] as? String {
                            // Create a User object with id and username only
                            let friend = User(id: friendID, fullname: "", username: friendUsername, email: "", friends: [])
                            friendsList.append(friend)
                        }
                    }

                    // Pass the fetched friends to the completion handler
                    completion(friendsList)
                } else {
                    print("User document not found")
                    completion([])
                }
            }
        }
    }

    
    func fetchCourses() {
        Courses.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Courses")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let city = data["city"] as? String ?? ""
                    
                    let course = GolfCourse(id: id, city: city)
                    self.Courses.append(course)
                }
            }
        }
    }
    
    // Fetch user data from Firestore
        func fetchUserData() {
            users.removeAll() // Clear existing data
            let db = Firestore.firestore()
            let usersCollection = db.collection("Users")
            
            usersCollection.getDocuments { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let id = data["id"] as? Int ?? 0
                        let email = data["email"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let friends = data["friends"] as? [User] ?? []
                        
                        let user = User(id: id, fullname: name, username: username, email: email, friends: friends)
                        self.users.append(user)
                    }
                }
            }
        }

    func changeUsername(newUsername: String) {
            guard let currentUser = Auth.auth().currentUser else {
                print("No user is currently signed in")
                return
            }
            
            let db = Firestore.firestore()
            let usersCollection = db.collection("Users")
            
            let currentUserQuery = usersCollection.whereField("email", isEqualTo: currentUser.email ?? "")
            
            currentUserQuery.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        document.reference.updateData(["username": newUsername]) { error in
                            if let error = error {
                                print("Error updating username: \(error.localizedDescription)")
                            } else {
                                print("Username updated successfully!")
                                // Optionally, you can update the local user data here
                            }
                        }
                    } else {
                        print("User document not found")
                    }
                }
            }
        }
    
    func getCurrentUsername() -> String? {
        if let currentUser = Auth.auth().currentUser {
            if let user = users.first(where: { $0.email == currentUser.email }) {
                return user.username // Return the username of the current user
            }
        }
        return nil // Return nil if the user is not found or not signed in
    }

    
    func addFriend(userEmail: String, friend: User) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently signed in")
            return
        }
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        // Query for the user document based on their email
        _ = usersCollection.whereField("email", isEqualTo: userEmail)
        let currQuery = usersCollection.whereField("email", isEqualTo: currentUser.email ?? "def-Email")
        
        currQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
            } else {
                if let document = querySnapshot?.documents.first {
                    // Get the ID of the current user
                    _ = currentUser.uid
                    
                    var updatedFriends = document.data()["friends"] as? [[String: Any]] ?? [] // Retrieve current friends list or initialize an empty array
                    
                    // Create dictionary representing the new friend
                    let newFriend: [String: Any] = [
                        "id": friend.id,
                        "username": friend.username
                    ]
                    
                    // Append the new friend to the friends list
                    updatedFriends.append(newFriend)
                    
                    // Update the friends field in Firestore
                    document.reference.updateData(["friends": updatedFriends]) { error in
                        if let error = error {
                            print("Error updating friends list: \(error.localizedDescription)")
                        } else {
                            print("Friend added successfully!")
                            
                            // Fetch and update the userFriends array
                            self.displayFriendsList { friends in
                                self.userFriends = friends
                            }
                        }
                    }
                } else {
                    print("User document not found")
                }
            }
        }
    }
    
    func removeFriend(userEmail: String, friendUsername: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently signed in")
            return
        }
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        let currQuery = usersCollection.whereField("email", isEqualTo: currentUser.email ?? "def-Email")
        
        currQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
            } else {
                if let document = querySnapshot?.documents.first {
                    var updatedFriends = document.data()["friends"] as? [[String: Any]] ?? [] // Retrieve current friends list or initialize an empty array
                    
                    // Remove the friend from the friends list
                    updatedFriends.removeAll { friend in
                        if let username = friend["username"] as? String {
                            return username == friendUsername
                        }
                        return false
                    }
                    
                    // Update the friends field in Firestore
                    document.reference.updateData(["friends": updatedFriends]) { error in
                        if let error = error {
                            print("Error updating friends list: \(error.localizedDescription)")
                        } else {
                            print("Friend removed successfully!")
                            
                            // Fetch and update the userFriends array
                            self.displayFriendsList { friends in
                                self.userFriends = friends
                            }
                        }
                    }
                } else {
                    print("User document not found")
                }
            }
        }
    }

    
    func addCourse(courseCity: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Courses").document(courseCity)
        ref.setData(["city": courseCity, "id": 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
            
            
    func addUser(email: String, fullname: String, username: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        let usersQuery = usersCollection.order(by: "id", descending: true).limit(to: 1)
        
        // Retrieve the last user document
        usersQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                var newId = 1 // Default ID if no documents exist
                if let lastDocument = querySnapshot?.documents.first {
                    // If documents exist, increment the last ID by 1
                    if let lastId = lastDocument.data()["id"] as? Int {
                        newId = lastId + 1
                    }
                }
                
                // Create a reference to a new document without specifying an ID
                let newUserRef = usersCollection.document()
                
                newUserRef.setData(["email": email, "id": newId, "name": fullname, "username": username, "friends": []]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // After adding the new user, update the user data
                        self.fetchUserData()
                    }
                }
            }
        }
    }

    
    func getCurrentFullName() -> String? {
            if let currentUser = Auth.auth().currentUser {
                if let user = users.first(where: { $0.email == currentUser.email }) {
                    return user.fullname // Return the full name of the current user
                }
            }
            return nil // Return nil if the user is not found or not signed in
        }
    }
        
