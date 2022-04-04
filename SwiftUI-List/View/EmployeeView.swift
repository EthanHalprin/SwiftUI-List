//
//  EmployeeView.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//
import SwiftUI

struct EmployeeView: View {

    var name: String
    var role: String
    var image: String
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "http://www.example.com")) { image in
                image
                    .resizable()
                    .clipShape(Circle())
            } placeholder: {
                if timeRemaining == 0 {
                    Image("default-female-avatar")
                        .resizable()
                        .frame(width: 44, height: 44)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 34, height: 34)
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(Color(.label))
                Text("\(role)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color(.systemIndigo))
            }
        }.onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}
