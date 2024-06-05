//
//  NewCourseView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-07.
//

import SwiftUI

struct NewCourseView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newCourse = ""
    
    var body: some View {
        VStack {
            TextField("Golf Course", text: $newCourse)
            Button {
                dataManager.addCourse(courseCity: newCourse)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

#Preview {
    NewCourseView()
}
