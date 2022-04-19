//
//  ListView.swift
//  SwiftUI-List
//
//  Created by Ethan on 09/03/2022.
//
import SwiftUI


struct NetworkError: Identifiable {
    var id = UUID()
    var code: Int
    var title: String
    var description: String
}

struct ListView: View {

    @StateObject var viewModel = ViewModel(url: "https://raw.githubusercontent.com/EthanHalprin/github_EthanHalprin.github.io/master/company_repo.json")
    
    @State var didError = false
    @State var networkError = NetworkError(code: 404, title: "title", description: "Error Message")

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
                self.networkError.title = "Network"
                if let urlError = error as? URLError {
                    self.networkError.code = urlError.code.rawValue
                }
                self.networkError.description = error.localizedDescription
                didError = true
            }
        }
        .alert(networkError.title, isPresented: $didError, presenting: networkError) { error in
            Button {
                print("Network error alert closed")
            } label: {
                Text("Close")
            }
        } message: { error in
            Text("\nError \(error.code): " + error.description + "\n")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

