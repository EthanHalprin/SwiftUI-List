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
        
            Text("\(hat.title)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(hat.hatDescription)")
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()

            DetailsStack(hat: $hat)
        }
    }
}

struct DetailsStack: View {
    
    @Binding var hat: Hat
    
    var body: some View {
        HStack(spacing: 20) {
            
            // Type
            VStack {
                Text("TYPE")
                    .fontWeight(.semibold)
                    .font(.caption)
                    .padding()
                Text("\(hat.type)")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .italic()
            }
            
            // Animal
            VStack {
                Text("ANIMAL")
                    .fontWeight(.semibold)
                    .font(.caption)
                    .padding()
                Text("\(hat.animal)")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .italic()
            }
            
            // Size
            VStack {
                Text("SIZE")
                    .fontWeight(.semibold)
                    .font(.caption)
                    .padding()
                Text("\(hat.size)")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .italic()
            }
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
