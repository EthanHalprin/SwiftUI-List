//
//  HatDetailsView.swift
//  SwiftUI-List
//
//  Created by Ethan on 02/05/2022.
//

import SwiftUI


struct HatDetailsView: View {
    
    @State var hat: Hat
    let width: CGFloat = 300.0
    
    var body: some View {
        
        VStack {
            Image("FreeVector-Hat-Illustration")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: 200)
                .padding(.bottom, 15)
        
            Text("\(hat.title)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(hat.hatDescription)")
                .multilineTextAlignment(.center)
                .font(.body)
                .minimumScaleFactor(0.1)
                .padding()

            DetailsStack(hat: $hat, width: width)
                .padding()
            
            Spacer()
            
            AddToCartButtonView()
            
            Spacer()
        }
        .frame(width: width, height: 550)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 50)
        .overlay(Button(action: {
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
                                pic: ""))
    }
}

//
// =========================== Auxillary struct ======================================================
//

struct DetailsStack: View {
    
    @Binding var hat: Hat
    var width: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            DetailsCellView(hat: $hat, key: "Type",   value: "\(hat.type)")
            DetailsCellView(hat: $hat, key: "Animal", value: "\(hat.animal)")
            DetailsCellView(hat: $hat, key: "Size",   value: "\(hat.size)")
        }
        .frame(width: width)
    }
}

struct DetailsCellView: View {
    
    @Binding var hat: Hat
    var key: String
    var value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(key)
                .padding()
            Text(value)
                .foregroundColor(.red)
                .fontWeight(.medium)
                .italic()
                .minimumScaleFactor(0.1)
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
                    .fontWeight(.medium)
                Image(systemName: "cart.badge.plus")
            }
            .frame(width: 200, height: 15, alignment: .center)
            .padding(8)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
    }
}
