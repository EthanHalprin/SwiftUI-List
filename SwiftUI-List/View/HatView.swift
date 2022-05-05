//
//  HatView.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//
import SwiftUI


struct HatView: View {

    var viewModel: HatViewModel
    
    var body: some View {
        HStack {
            if let cachedImage = viewModel.cache.value(forKey: viewModel.hat.pic) {
                cachedImage
                    .resizable()
                    .frame(width: viewModel.width, height: viewModel.height)
            } else {
                AsyncImage(url: URL(string: viewModel.hat.pic)) { image in
                    image
                        .resizable()
                        .frame(width: viewModel.width, height: viewModel.height)
                        .onAppear {
                            viewModel.cache.insert(image, forKey: viewModel.hat.pic)
                        }
                } placeholder: {
                    Image("stockio.com.hat")
                        .resizable()
                        .frame(width: viewModel.width, height: viewModel.height)
                }
            }
            
            HatViewTextStack(title: viewModel.hat.title,
                             animal: viewModel.hat.animal,
                             primaryFontSize: viewModel.primaryFontSize,
                             secondaryFontSize: viewModel.secondaryFontSize)
        }
    }
}

struct HatViewTextStack: View {
    
    var title: String
    var animal: String
    var primaryFontSize: CGFloat
    var secondaryFontSize: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: primaryFontSize,
                              weight: .medium,
                              design: .default))
                .foregroundColor(Color(.label))
            Text(animal)
                .font(.system(size: secondaryFontSize,
                              weight: .regular,
                              design: .default))
                .foregroundColor(Color(.systemIndigo))
        }
    }
}
