//
//  PageViewController.swift
//  SwiftUI-List
//
//  Created by Ethan on 28/04/2022.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        PageSliderView(["Page #0", "Page #1", "Page #2"])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PageSliderView(["Page #0", "Page #1", "Page #2"])
    }
}

//
// The SwiftUI View to be inserted into a single controller
//
struct PageView: View {
    
    var data: String
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            Text(self.data)
                .font(.title)
                .foregroundColor(Color.black)
        }
    }
}

//
// An Observavle class to accommodate the page num to be tranferred to
//
class TransitionTrigger: ObservableObject {
    @Published var pageNum = 0
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
struct PageSliderView: View {
    
    var controllers = [UIHostingController<PageView>]()
    @StateObject var transitionTrigger = TransitionTrigger()
    
    init(_ data: [String]) {
        self.controllers = data.map({ UIHostingController(rootView: PageView(data: $0)) })
    }
    
    var body: some View {
        PageViewController(controllers: controllers, transitionTrigger: transitionTrigger)
            .overlay(alignment: .bottom) {
                PageIndicatorView(transitionTrigger: transitionTrigger)
            }
    }
}

//
// PageIndicatorView to encapsulate and create a UIKit UIPageControl
//
struct PageIndicatorView: UIViewRepresentable {
    
    typealias UIViewType = UIPageControl
    @ObservedObject var transitionTrigger: TransitionTrigger

    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .white
        return pageControl
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = transitionTrigger.pageNum
    }
}

//
// A UIKit struct for generating an UIPageViewController & accommodating
// the UIViewControllers to be presented
//
struct PageViewController: UIViewControllerRepresentable {
    
    var controllers : [UIViewController]?
    @ObservedObject var transitionTrigger: TransitionTrigger
   
    typealias UIViewControllerType = UIPageViewController

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        if let controller0 = self.controllers?[0] {
            uiViewController.setViewControllers([controller0],
                                                direction: .forward,
                                                animated: true)
        }
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

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        let parent: PageViewController // <- we'll need this to get to the controllers
        
        init( _ parent: PageViewController) {
            self.parent = parent
        }

        //UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let controllers = self.parent.controllers else { return nil }
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return controllers.last
            }

            return controllers[index - 1]
        }
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let controllers = self.parent.controllers else { return nil }
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index == controllers.count - 1 {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        //UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            guard let controllers = self.parent.controllers else { return }
            
            var index = 0
            for (i, vc) in controllers.enumerated() {
                if vc == pendingViewControllers.first {
                    index = i
                    break
                }
            }
            self.parent.transitionTrigger.pageNum = index
        }
    }
}
