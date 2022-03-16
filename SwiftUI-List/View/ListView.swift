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
                             image: employee.pic)
            }.listStyle(GroupedListStyle())
             .overlay {
                 if viewModel.fetching {
                     ProgressView("Fetching data, please wait...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                 }
             }
            // this animation is only run when the contents of the list view changes
            .animation(.default, value: viewModel.employees)
            .navigationBarTitle("Employees")
            .toolbar {
                ToolbarItem {
                    //
                    // Uncomment this to apply action to the bar button:
                    // NavigationLink(destination: SomeView()) {
                    //
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 25))
                        .foregroundColor(.blue)
                    //}
                }
            } // .tooolbar
        } // NavigationView
        .task {
            
            // If you wanna watch the ProgressBar - uncomment this
            // line and comment the following do-catch block
            //
            // await viewModel.fetchEmployees(latency: 4)

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
