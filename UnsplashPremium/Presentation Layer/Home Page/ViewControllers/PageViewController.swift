
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    private let viewModel: HomeViewModel
    
    private let topicBar: TopicBar = {
        let topicBar = TopicBar()
        return topicBar
    }()
    
    private let unsplashView: UIImageView = {
        let unsplashView = UIImageView()
        let image = UIImage(named: "unsplash")
        unsplashView.image = image?.withRenderingMode(.alwaysTemplate)
        unsplashView.contentMode = .scaleAspectFit
        unsplashView.frame.size.height = 20
        return unsplashView
    }()
    
    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        logoView.image = image?.withRenderingMode(.alwaysTemplate)
        logoView.tintColor = .white
        return logoView
    }()
    
    private let gradientView: GradientView = {
        let gradientView = GradientView(gradientColor: .black)
        return gradientView
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var orderedViewControllers: [UIViewController] = {
        let model = HomeViewModel(photosService: PhotosServiceImplementation())
        return [EditorialPage(viewModel: model)]
    }()
    
    //making navigation bar transparent
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        fetchData()
        setupPageController()
        self.navigationItem.titleView = unsplashView
        navigationItem.titleView?.tintColor = .white
        
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(65)
        }
        view.addSubview(logoView)
        logoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            $0.size.equalTo(20)
        }
        setUpMenuBar()
    }
    private func bindViewModel(){
        
        //Task: When topics are loaded, update the topicBar, and pages accordingly
        viewModel.didLoadTopics = { [weak self] topics in
            self?.topicBar.updateTopics(with: topics.map(
                {
                    let topic = Topic(id: $0.id, title: $0.title)
                    self?.orderedViewControllers.append(
                        TopicPage(
                            viewModel: HomeViewModel(photosService: PhotosServiceImplementation()),
                            topic: topic
                        )
                    )
                    return topic
                }))
        }
    }
    
    private func fetchData() {
        viewModel.getAllTopics()
    }
    
    private func setUpMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        view.addSubview(topicBar)
        topicBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        topicBar.didTapBarItem = { row in
            let currentViewController = self.orderedViewControllers[row]
            self.setViewControllers([currentViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func setupPageController() {
        view.backgroundColor = UIColor.clear
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let visibleViewController = pageViewController.viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: visibleViewController)
        {
            topicBar.chooseTopic(at: index)
        }
    }
    
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
}
