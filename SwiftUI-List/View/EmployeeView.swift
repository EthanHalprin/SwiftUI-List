//
//  EmployeeView.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//
import SwiftUI

struct EmployeeView: View {

    @State private var timeRemaining = 3
    var name: String
    var role: String
    var url: String
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let cache: ImageCache

    var body: some View {
        HStack {
            if let cachedImage = cache.getImage(by: url) {
                cachedImage
                    .resizable()
                    .clipShape(Circle())
            } else {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .onAppear {
                            self.cache.setImage(image, url: self.url)
                        }
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
            }
        }.onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}
