//
//  DetailsView.swift
//  SwiftUI-List
//
//  Created by Ethan on 25/04/2022.
//

import SwiftUI


struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    var hat: Hat
    
    var body: some View {
        Button("\(hat.animal)!") {
            dismiss()
        }
        .font(.title3)
        .padding()
        .background(Color.blue)
        .foregroundColor(Color.yellow)
    }
}
