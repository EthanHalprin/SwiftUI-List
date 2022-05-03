//
//  HatDetailsView.swift
//  SwiftUI-List
//
//  Created by Ethan on 02/05/2022.
//

import SwiftUI

struct HatDetailsView: View {
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        
        ZStack {
  
            Color.red
                .ignoresSafeArea()
            
            VStack {

                Image("FreeVector-Hat-Illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: screenHeight * 0.33)
                
                DetailsMainText(title: "German Sheperd", description: "A hat carrying a german sheperd icon in olive green full color")
                    .padding(.bottom, 50)

                AddButtonView()
            }
            .frame(width: screenWidth * 0.8, height: screenHeight * 0.8)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 40)
        }
    }
}

struct HatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HatDetailsView()
    }
}

struct DetailsMainText: View {
    
    var title: String
    var description: String

    var body: some View {
        
        VStack(alignment: .center) {
            Text("\(self.title)")
                .fontWeight(.bold)
                .font(.body)
                .padding()
        
            Text("\(self.description)")
                .fontWeight(.regular)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.bottom, 30)

                        
            HStack(spacing: 50) {
                HatFeatureView(key: "type", value: "Mesh")
                HatFeatureView(key: "size", value: "OS")
                HatFeatureView(key: "price", value: "$$")
            }
        }
    }
}

struct HatFeatureView: View {
    
    var key: String
    var value: String
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Text("\(self.key)")
                .foregroundColor(Color.black)
                .font(.body)
                .fontWeight(.medium)

            Text("\(self.value)")
                .foregroundColor(Color.blue)
                .font(.body)
                .fontWeight(.regular)
        }
    }
}

struct AddButtonView: View {
    var body: some View {
        Button(action: /* ("Delete", role: .destructive) */  {
            print("Add Button action")
        }) {
            HStack(spacing: 10) {
                Text("Add")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Image(systemName: "cart.badge.plus")
            }
            .frame(width: 150, height: 30, alignment: .center)
            .padding(10.0)
            .background(Color(red: 0.2, green: 0.4, blue: 0.85))
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
    }
}
