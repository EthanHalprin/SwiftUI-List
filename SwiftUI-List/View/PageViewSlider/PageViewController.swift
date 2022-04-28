//
//  PageViewController.swift
//  SwiftUI-List
//
//  Created by Ethan on 28/04/2022.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ContainerView(["PaGe 1", "PaGe 2", "PaGe 3"])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(["PaGe 1", "PaGe 2", "PaGe 3"])
    }
}
//
// The SwiftUI View to be inserted into a single controller
//
struct PageView: View {
    
    var data: String
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            Text(self.data)
                .font(.headline)
                .foregroundColor(Color.yellow)
        }
    }
}
//
// A SwiftUI struct for holding & filling the PageViewController with real
// controllers.
//
// *Remark:
//
//   In this case the controllers need to be a PageView. But the latter is
//   a SwiftUI struct, while PageViewController demands the controllers
//   be of [UIViewController] type.
//   This is the case for UIHostingController (applied when we need to
//   accommodate a SwiftUI struct (PageView) inside an UIKit struct
//   in PageViewController)
//
struct ContainerView: View {
    
    var controllers = [UIHostingController<PageView>]()
    
    init(_ data: [String]) {
        self.controllers = data.map({ UIHostingController(rootView: PageView(data: $0)) })
    }
    
    var body: some View {
        return PageViewController(controllers: controllers)
    }
}
//
// A UIKit struct for generating an UIPageViewController & accommodating
// the UIViewControllers to be presented
//
struct PageViewController: UIViewControllerRepresentable {
    
    let controllers : [UIViewController]

    //
    // Compliance to UIViewControllerRepresentable
    //
    typealias UIViewControllerType = UIPageViewController

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([self.controllers[0]],
                                            direction: .forward,
                                            animated: true)
    }
    
    //
    // Coordinator class here is for supplying the data source and the motion in the slide.
    // (The data source part - see initialization in 'makeUIViewController')
    
    // Usually in UIKit we would have implemented the protocol 'UIPageViewControllerDataSource'.
    // However, PageViewController is NOT a SwiftUI struct, therefore we can't
    // make it comply to 'UIPageViewControllerDataSource' (you can try for yourself and see the error).
    //
    // The solution here is to make PageViewController comply to 'UIViewControllerRepresentable' :
    //
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        
        let parent: PageViewController // <- we'll need this to get to the controllers
        
        init( _ parent: PageViewController) {
            self.parent = parent
        }

        // this compliance supports the motion
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return self.parent.controllers.last
            }
            return self.parent.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = self.parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == self.parent.controllers.count - 1 {
                return self.parent.controllers.first
            }
            return self.parent.controllers[index + 1]
        }
        
    }
}
