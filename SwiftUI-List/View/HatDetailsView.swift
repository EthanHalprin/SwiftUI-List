//
//  HatDetailsView.swift
//  SwiftUI-List
//
//  Created by Ethan on 02/05/2022.
//

import SwiftUI


struct HatDetailsView: View {
    
    var hat: Hat
    var cache: Cache<String, Image>
    @Binding var isShowing: Bool

    var body: some View {
        
        VStack {
            if let cachedImage = self.cache.value(forKey: hat.pic) {
                cachedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 190)
            } else {
                AsyncImage(url: URL(string: hat.pic)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 190)
                        .onAppear {
                            self.cache.insert(image, forKey: hat.pic)
                        }
                } placeholder: {
                    Image("stockio.com.hat")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 190)
                }
            }

            Text("\(hat.title)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(hat.hatDescription)")
                .multilineTextAlignment(.center)
                .font(.body)
                .minimumScaleFactor(0.1)
                .padding()

            DetailsStack(hat: hat)
                .frame(minWidth: 300, maxHeight: 40, alignment: .center)
                     
            Spacer()

            AddToCartButtonView()
            
            Spacer()
        }
        .frame(width: 300, height: 560)
        .background(Color(.white))
        .cornerRadius(15)
        .shadow(radius: 50)
        .overlay(Button(action: {
            self.isShowing = false
        }) {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.white)
                    .opacity(0.6)
                
                Image(systemName: "xmark")
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(Color.red)
                }
                .padding(5)
            } ,
            alignment: .topTrailing)
    }
}

struct HatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HatDetailsView(hat: Hat(id: "1234",
                                type: "mesh",
                                animal: "German Sheperd",
                                title: "Bouncer",
                                size: "OS",
                                hatDescription: "An olive green mesh hat with cap",
                                pic: ""),
                       cache: Cache<String, Image>(),
                       isShowing: .constant(true))
    }
}

//
// =========================== Infrastructure ======================================================
//

struct DetailsStack: View {
    
    var hat: Hat

    var body: some View {
        HStack(spacing: 10) {
            DetailsCellView(hat: hat, key: "Type",   value: "\(hat.type)")
            DetailsCellView(hat: hat, key: "Animal", value: "\(hat.animal)")
            DetailsCellView(hat: hat, key: "Size",   value: "\(hat.size)")
        }
    }
}

struct DetailsCellView: View {
    
    var hat: Hat
    var key: String
    var value: String
    
    var body: some View {
        VStack {
            Text(key)
                .foregroundColor(.brown)
                .font(Font.custom("Courier New", size: 15.0))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.8)
                .padding()
            Text(value)
                .foregroundColor(.blue)
                .fontWeight(.medium)
                .italic()
                .minimumScaleFactor(0.8)
        }
    }
}

struct AddToCartButtonView: View {
    var body: some View {
        Button(action: {
            print("Add Button action")
        }) {
            HStack(spacing: 10) {
                Text("Add")
                    .font(.callout)
                    .fontWeight(.semibold)
                Image(systemName: "cart.badge.plus")
            }
            .frame(width: 200, height: 20, alignment: .center)
            .padding(8)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
    }
}
