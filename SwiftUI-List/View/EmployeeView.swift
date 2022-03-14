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
                //https://www.iconbunny.com/icons/media/catalog/product/1/2/1282.12-business-woman-icon-iconbunny.jpg
                Text("\(name)")
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text("\(role)")
                    .font(.system(size: 13, weight: .light, design: .default))
                    .foregroundColor(.blue)
            }
        }
    }
}
