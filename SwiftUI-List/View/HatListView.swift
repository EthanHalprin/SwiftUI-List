//
//  ListView.swift
//  SwiftUI-List
//
//  Created by Ethan on 09/03/2022.
//
import SwiftUI


struct HatListView: View {

    @StateObject var viewModel = ListViewModel()
    @State var isDetailsViewShowing = false

    var body: some View {
            
        NavigationView {
            ZStack {
                List(self.viewModel.hats) { hat in
                    HatView(viewModel: HatViewModel(hat: hat))
                        .listRowSeparator(.visible)
                        .listRowSeparatorTint(.black)
                        .onTapGesture {
                            self.isDetailsViewShowing = true
                        }
                }.listStyle(PlainListStyle())
                 .padding()
                 .overlay {
                     FetcherOverlayView(fetching: $viewModel.fetching)
                 }
                 .animation(.default, value: viewModel.hats)
                 .toolbar {
                     Button { self.viewModel.refreshMerchandise() }
                     label: { Image(systemName: "arrow.counterclockwise") }
                 }
                 .navigationTitle("Mesh Truckers")
                 .disabled(isDetailsViewShowing)
                 .task {
                     await fetchTaskHandler()
                 }
                 .blur(radius: self.isDetailsViewShowing ? 10 : 0)

                if isDetailsViewShowing {
                    HatDetailsView(hat: Hat(id: "1234",
                                            type: "mesh",
                                            animal: "German Sheperd",
                                            title: "Bouncer",
                                            size: "OS",
                                            hatDescription: "An olive green mesh hat with cap",
                                            pic: ""),
                                   isShowing: $isDetailsViewShowing)
                }

            } // ZStack
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
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        HatListView()
    }
}

extension HatListView {
    fileprivate func fetchTaskHandler() async {
        do {
            try await viewModel.fetchData()
        } catch {
            print("Fetching data failed with error: \(error.localizedDescription)")
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

struct FetcherOverlayView: View {
    
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
