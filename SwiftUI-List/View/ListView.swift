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
            List(self.viewModel.employees) { employee in
                EmployeeView(name: employee.name,
                             role: employee.title,
                             imageName: "business-woman-icon-iconbunny")
            }.listStyle(GroupedListStyle())
             .navigationBarTitle("Employees")
             .toolbar {
                ToolbarItem {
                    //NavigationLink(destination: SettingsView()) {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                    //}
                }
            }
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
