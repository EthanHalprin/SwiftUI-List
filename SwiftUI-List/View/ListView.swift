//
//  ListView.swift
//  SwiftUI-List
//
//  Created by Ethan on 09/03/2022.
//
import SwiftUI


struct ListView: View {

    @StateObject var viewModel = ViewModel(url: "https://raw.githubusercontent.com/EthanHalprin/github_EthanHalprin.github.io/master/company_repo.json")

    var body: some View {
        NavigationView {
            Text("List coming soon")
                .navigationBarTitle(Text("Employees"))
                .navigationBarItems(trailing: Button(action: {
                                    // do something
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .imageScale(.large)
                                })
        }
        .onAppear {
            viewModel.load()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
