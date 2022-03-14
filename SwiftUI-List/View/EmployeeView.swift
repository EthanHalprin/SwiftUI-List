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
    var imageName: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 34, height: 34)
            VStack(alignment: .leading) {
                //https://png.pngtree.com/png-clipart/20190520/original/pngtree-business-woman-line-filled-icon-png-image_3789239.jpg
                Text("\(name)")
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text("\(role)")
                    .font(.system(size: 13, weight: .light, design: .default))
                    .foregroundColor(.blue)
            }
        }
    }
}
