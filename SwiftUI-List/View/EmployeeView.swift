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
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 34, height: 34)
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text("\(role)")
                    .font(.system(size: 13, weight: .light, design: .default))
                    .foregroundColor(.blue)
            }
        }
    }
}
