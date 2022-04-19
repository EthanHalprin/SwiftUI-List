//
//  ListView.swift
//  SwiftUI-List
//
//  Created by Ethan on 09/03/2022.
//
import SwiftUI


struct ListView: View {

    @StateObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationView {
            List(self.viewModel.hats) { hat in
                HatView(viewModel: HatViewModel(hat: hat))
                    .listRowSeparator(.visible)
                    .listRowSeparatorTint(.black)
            }.listStyle(PlainListStyle())
             .padding(.top, 20)
             .overlay {
                 FetcherOverlay(fetching: $viewModel.fetching)
             }
             .animation(.default, value: viewModel.hats)
             .navigationBarTitle("Mesh Truckers")
             .toolbar {
                 Button { self.viewModel.refreshMerchandise() }
                 label: { Image(systemName: "arrow.counterclockwise") }
             }
        }
        .task { await fetchTaskHandler() }
        .alert(viewModel.networkError?.title ?? "Error",
               isPresented: $viewModel.didError,
               presenting: viewModel.networkError) { error in
            Button {
                print("Network error alert closed")
            }
            label: {
                Text("Close")
            }
        } message: { error in
            Text("\nError \(error.code): " + error.description + "\n")
        }
    }
}

struct FetcherOverlay: View {
    
    @Binding var fetching: Bool
    
    var body: some View {
        if fetching {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            ProgressView("Fetching data, please wait...")
               .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
        }
    }
}

extension ListView {
    fileprivate func fetchTaskHandler() async {
        do {
            try await viewModel.fetchMerchandise()
        } catch {
            print("Fetching merchandise failed with error: \(error.localizedDescription)")
            guard let urlError = error as? URLError else {
                fatalError("Unknown Error. If this keeps happening, contact your system administrator")
            }
            self.viewModel.networkError = NetworkError(code: urlError.code.rawValue,
                                                       title: "Network Error",
                                                       description: urlError.localizedDescription)
            DispatchQueue.main.async {
                self.viewModel.didError = true
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

