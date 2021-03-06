
import UIKit
import Alamofire


//MARK: - Set All Pages, Topic Bar, and Logo

class HomePageViewController: UIPageViewController {
    
    private let viewModel: HomePageViewModel
    
    private let topicBar: TopicBar = {
        let topicBar = TopicBar()
        return topicBar
    }()
    
    private let logoNameView: UIImageView = {
        let logoNameView = UIImageView()
        let image = UIImage(named: "unsplash")
        logoNameView.image = image?.withRenderingMode(.alwaysTemplate)
        logoNameView.contentMode = .scaleAspectFit
        logoNameView.frame.size.height = 20
        return logoNameView
    }()
    
    private let logoIconView: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "logo")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapLogo), for: .touchUpInside)
        return button
    }()
    
    private let topBlackGradient: GradientView = {
        let topBlackGradient = GradientView(gradientColor: .black)
        return topBlackGradient
    }()
    
    @objc private func didTapLogo(){
        present(UnsplashInfoViewController(), animated: true, completion: nil)
    }
    
    init(viewModel: HomePageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //subpages
    private var orderedSubViewControllers: [UIViewController] = {
        let model = HomePageViewModel(photosService: PhotosServiceImplementation())
        return [EditorialPage(viewModel: model)]
    }()
    
    
    //making navigation bar transparent and hidable
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.titleView?.tintColor = .white
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: ColorKeys.background)
        navigationItem.titleView = logoNameView
        dataSource = self
        delegate = self
        bindViewModel()
        fetchData()
        layout()
        setUpMenuBar()
        setUpInitialPage()
    }
    
    private func layout(){
        view.addSubview(topBlackGradient)
        topBlackGradient.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(65)
        }
        
        view.addSubview(topicBar)
        topicBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        view.addSubview(logoIconView)
        logoIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            $0.size.equalTo(25)
        }
    }
    
    private func bindViewModel(){
        // When topics are loaded: update the topic bar $ topic pages accordingly
        viewModel.didLoadTopics = { [weak self] topics in
            self?.topicBar.updateTopics(
                with: topics.map(
                    {
                        let topic = Topic(
                            id: $0.id,
                            title: $0.title,
                            description: $0.topicDescription,
                            totalPhotos: $0.totalPhotos,
                            coverPhotoUrlString: $0.coverPhoto.urls.small,
                            previewPhotos: $0.previewPhotos
                        )
                        self?.appendTopicPage(with: topic)
                        
                        return topic
                    }
                )
            )
        }
    }
    
    private func appendTopicPage(with topic: Topic) {
        orderedSubViewControllers.append(
            TopicPage(
                viewModel: HomePageViewModel(photosService: PhotosServiceImplementation()),
                topic: topic
            ))
    }
    
    private func fetchData() {
        viewModel.getAllTopics()
    }
    
    private func setUpMenuBar() {
        
        // When Specific Topic is Selected on Topic Bar: Move Pages accordingly
        topicBar.didSelectBarItem = { [weak self] selectedIndex in
            
            guard let strongSelf = self,
                  let vc = strongSelf.viewControllers?.first,
                  let currentIndex = strongSelf.orderedSubViewControllers.firstIndex(of: vc) else { return }
            
            let currentViewController = strongSelf.orderedSubViewControllers[selectedIndex]
            
            let difference = selectedIndex - currentIndex
            
            //if the selected topic is just the next, animate right
            if difference == 1 {
                strongSelf.setViewControllers(
                    [currentViewController],
                    direction: .forward,
                    animated: true,
                    completion: nil)
                
            //if the selected topic is just the previous, animate left
            } else if difference == -1 {
                strongSelf.setViewControllers(
                    [currentViewController],
                    direction: .reverse,
                    animated: true,
                    completion: nil)
                
            //else, just open page
            } else {
                strongSelf.setViewControllers(
                    [currentViewController],
                    direction: .reverse,
                    animated: false,
                    completion: nil)
                
            }
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

extension HomePageViewController: UIPageViewControllerDataSource {
    
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

extension HomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed,
           let visibleViewController = pageViewController.viewControllers?.first,
           let index = orderedSubViewControllers.firstIndex(of: visibleViewController)
        {
            topicBar.chooseTopic(at: index)
        }
    }
    
}


extension UINavigationBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard nestedInteractiveViews(in: self, contain: point) else { return false }
        return super.point(inside: point, with: event)
    }

    private func nestedInteractiveViews(in view: UIView, contain point: CGPoint) -> Bool {
        if view.isPotentiallyInteractive, view.bounds.contains(convert(point, to: view)) {
            return true
        }

        for subview in view.subviews {
            if nestedInteractiveViews(in: subview, contain: point) {
                return true
            }
        }

        return false
    }
}

private extension UIView {
    var isPotentiallyInteractive: Bool {
        guard isUserInteractionEnabled else { return false }
        return (isControl || doesContainGestureRecognizer)
    }

    var isControl: Bool {
        return self is UIControl
    }

    var doesContainGestureRecognizer: Bool {
        return !(gestureRecognizers?.isEmpty ?? true)
    }
}
