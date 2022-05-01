//
//import UIKit
//
//class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
//    
//    var currentIndex = 0
//    
//    let savedNotesController = HomeViewController()
//    let writeNotesController = SecondViewController()
//    lazy var orderedViewControllers: [UIViewController] = {
//        return [self.savedNotesController, self.writeNotesController]
//    }()
//    
//    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupPageController()
////        for subview in self.view.subviews {
////            if let scrollView = subview as? UIScrollView {
////                scrollView.delegate = self
////                break;
////            }
////        }
//    }
//    
//    func setupPageController() {
//        view.backgroundColor = UIColor.clear
//        
//        dataSource = self
//        delegate = self
//        
//        if let firstViewController = orderedViewControllers.first {
//            setViewControllers([firstViewController],
//                               direction: .forward,
//                               animated: true,
//                               completion: nil)
//        }
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//            if completed,
//                let visibleViewController = pageViewController.viewControllers?.first,
//                let index = orderedViewControllers.firstIndex(of: visibleViewController)
//            {
//                currentIndex = index
//                
//            }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//extension PageViewController: UIPageViewControllerDataSource {
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        
//        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
//            return nil
//        }
//        
//        let previousIndex = viewControllerIndex - 1
//        
//        guard previousIndex >= 0 else {
//            return nil
//        }
//        
//        guard orderedViewControllers.count > previousIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[previousIndex]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        
//        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
//            return nil
//        }
//        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = orderedViewControllers.count
//        
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//        return orderedViewControllers[nextIndex]
//    }
//}
//
//extension PageViewController: UIScrollViewDelegate {
//    
//}
