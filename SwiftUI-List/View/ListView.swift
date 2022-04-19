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
            await fetchTaskHandler()
        }
        .alert(viewModel.networkError?.title ?? "", isPresented: $viewModel.didError, presenting: viewModel.networkError) { error in
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

extension ListView {
    fileprivate func fetchTaskHandler() async {
        do {
            try await viewModel.fetchEmployees()
        } catch {
            print("Fetching employees failed with error: \(error.localizedDescription)")
            guard let urlError = error as? URLError else {
                fatalError("Unknown Error. If this keeps happening, contact your system administrator")
            }
            self.viewModel.networkError = NetworkError(code: urlError.code.rawValue,
                                                       title: "Network",
                                                       description: urlError.localizedDescription)
            self.viewModel.didError = true
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

