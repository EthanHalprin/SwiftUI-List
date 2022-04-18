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
                             url: employee.pic,
                             cache: self.viewModel.cache)
            }.listStyle(GroupedListStyle())
             .overlay {
                 if viewModel.fetching {
                     Color(.systemBackground)
                         .edgesIgnoringSafeArea(.all)
                     ProgressView("Fetching data, please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                 }
             }
             .animation(.default, value: viewModel.employees)
             .navigationBarTitle("Employees")
             .toolbar {
                 Button {
                     self.viewModel.refreshEmployees()
                 } label: {
                     Image(systemName: "arrow.counterclockwise") // 􀅉
                 }
             }
        }
        .task {
            do {
                try await viewModel.fetchEmployees()
            } catch {
                print("Fetching employees failed with error: \(error.localizedDescription)")
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
