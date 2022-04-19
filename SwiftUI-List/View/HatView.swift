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
            if let cachedImage = viewModel.cache?.getImage(by: viewModel.hat?.pic ?? MockSample.emptyHat.pic) {
                cachedImage
                    .resizable()
                    .frame(width: viewModel.width, height: viewModel.height)
            } else {
                AsyncImage(url: URL(string: viewModel.hat?.pic ?? "")) { image in
                    image
                        .resizable()
                        .frame(width: viewModel.width, height: viewModel.height)
                        .onAppear { viewModel.cache?.setImage(image, url: viewModel.hat?.pic ?? MockSample.emptyHat.pic) }
                } placeholder: {
                    if viewModel.picTimeout == 0 {
                        Image("stockio.com.hat")
                            .resizable()
                            .frame(width: viewModel.width, height: viewModel.height)
                    } else {
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("\(viewModel.hat?.title ?? "")")
                        .font(.system(size: viewModel.primaryFontSize,
                                      weight: .medium,
                                      design: .default))
                        .foregroundColor(Color(.label))
                    Text("\(viewModel.hat?.animal ?? "")")
                        .font(.system(size: viewModel.secondaryFontSize,
                                      weight: .regular,
                                      design: .default))
                        .foregroundColor(Color(.systemIndigo))
                }
            }
        }.onReceive(viewModel.timer) { time in
            if viewModel.picTimeout > 0 {
                viewModel.picTimeout -= 1
            }
        }
    }
}

struct MockSample {
    static let emptyHat = Hat(id: "000",
                              type: "",
                              animal: "N/A",
                              title: "N/A",
                              size: "",
                              hatDescription: " ",
                              pic: "")
}
