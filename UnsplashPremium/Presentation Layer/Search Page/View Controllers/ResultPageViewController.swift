//
//  ResultPageViewController.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit

class ResultPageViewController: UIPageViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Photos", "Collections", "Users"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = .darkGray
        segmentedControl.selectedSegmentTintColor = .lightGray
        segmentedControl.tintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.isUserInteractionEnabled = true
        segmentedControl.addTarget(self, action: #selector(segmentAction(segmentedControl:)), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc private func segmentAction(segmentedControl: UISegmentedControl){
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        guard let vc = self.viewControllers?.first,
              let currentIndex = self.orderedSubViewControllers.firstIndex(of: vc) else { return }
        
        let currentViewController = self.orderedSubViewControllers[selectedIndex]
        
        let difference = selectedIndex - currentIndex
        
        //if the selected topic is just the next, animate right
        if difference == 1 {
            self.setViewControllers(
                [currentViewController],
                direction: .forward,
                animated: true,
                completion: nil)
            
        //if the selected topic is just the previous, animate left
        } else if difference == -1 {
            self.setViewControllers(
                [currentViewController],
                direction: .reverse,
                animated: true,
                completion: nil)
            
        //else, just open page
        } else {
            self.setViewControllers(
                [currentViewController],
                direction: .reverse,
                animated: false,
                completion: nil)
            
        }
    }
    
    private var orderedSubViewControllers: [UIViewController]
    
    init(query: String){
        orderedSubViewControllers = [
            PhotoResultPage(
                with: PhotoResultViewModel(resultsService: SearchResultServiceImplementation()),
                query: query),
            CollectionResultPage(
                with: CollectionResultViewModel(resultsService: SearchResultServiceImplementation()),
                query: query),
            UserResultPage(
                with: UserResultViewModel(resultsService: SearchResultServiceImplementation()),
                query: query)
        ]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        self.view.clipsToBounds = false
        layout()
        setUpInitialPage()
        // Do any additional setup after loading the view.
    }
    
    private func layout(){
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(30)
        }
    }
    
    private func setUpInitialPage() {
        if let firstViewController = orderedSubViewControllers.first {
            setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: false,
                completion: nil)
        }
    }
}


//MARK: - Change Pages When Swiped

extension ResultPageViewController: UIPageViewControllerDataSource {
    
    //swiped left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedSubViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex == 0 {
            return nil
        }
        
        return orderedSubViewControllers[viewControllerIndex - 1]
    }
    
    //swiped right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedSubViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex == orderedSubViewControllers.count - 1 {
            return nil
        }
        return orderedSubViewControllers[viewControllerIndex + 1]
    }
}





//MARK: - Change Topic Bar When Swiped

extension ResultPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed,
           let visibleViewController = pageViewController.viewControllers?.first,
           let index = orderedSubViewControllers.firstIndex(of: visibleViewController)
        {
            segmentedControl.selectedSegmentIndex = index
        }
    }
}
