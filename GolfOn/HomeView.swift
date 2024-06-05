//
//  HomeView.swift
//  GolfOn
//
//  Created by Reece Melnick on 2024-04-11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to GolfOn")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .offset(x: -40, y: -230)
            
            Text("Click start to tee off")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Button(action: {
                //start new match
            }, label: {
                Text("Start")
                    .bold()
                    .frame(width: 250, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.linearGradient(colors: [.green, .black], startPoint: .top, endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            })
            Image(systemName: "figure.golf")
                .font(.system(size: 60, weight: .bold, design: .rounded))
        }
    }
}

#Preview {
    HomeView()
}
