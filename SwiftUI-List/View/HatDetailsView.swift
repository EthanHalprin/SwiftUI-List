//
//  HatDetailsView.swift
//  SwiftUI-List
//
//  Created by Ethan on 02/05/2022.
//

import SwiftUI


struct HatDetailsView: View {
    
    @State var hat: Hat

    var body: some View {
        
        VStack {
            Image("FreeVector-Hat-Illustration")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 225)
                .cornerRadius(15)
        
            Text("\(hat.title)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(hat.hatDescription)")
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()

            DetailsStack(hat: $hat)
                .padding()
            
            Spacer()
            
            AddToCartButtonView()
            
            Spacer()
        }
    }
}

struct DetailsStack: View {
    
    @Binding var hat: Hat
    
    var body: some View {
        HStack(spacing: 20) {
            DetailsCellView(hat: $hat, key: "TYPE",   value: "\(hat.type)")
            DetailsCellView(hat: $hat, key: "ANIMAL", value: "\(hat.animal)")
            DetailsCellView(hat: $hat, key: "SIZE",   value: "\(hat.size)")
        }
    }
}

struct DetailsCellView: View {
    
    @Binding var hat: Hat
    var key: String
    var value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(key)
                .font(.body)
                .padding()
            Text(value)
                .foregroundColor(.blue)
                .fontWeight(.medium)
                .font(.body)
                .italic()
        }
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

struct AddToCartButtonView: View {
    var body: some View {
        Button(action: {
            print("Add Button action")
        }) {
            HStack(spacing: 10) {
                Text("Add")
                    .font(.title3)
                    .fontWeight(.medium)
                Image(systemName: "cart.badge.plus")
            }
            .frame(width: 200, height: 20, alignment: .center)
            .padding(10.0)
            .background(Color(red: 0.2, green: 0.4, blue: 0.85))
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
    }
}
