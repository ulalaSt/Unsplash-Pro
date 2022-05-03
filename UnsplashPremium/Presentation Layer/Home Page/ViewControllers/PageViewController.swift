
import UIKit


//MARK: - Set All Pages, Topic Bar, and Logo

class PageViewController: UIPageViewController {
    
    private let viewModel: HomeViewModel
    
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
    
    private let logoIconView: UIImageView = {
        let logoIconView = UIImageView()
        logoIconView.contentMode = .scaleAspectFit
        logoIconView.tintColor = .white
        let image = UIImage(named: "logo")
        logoIconView.image = image?.withRenderingMode(.alwaysTemplate)
        return logoIconView
    }()
    
    private let topBlackGradient: GradientView = {
        let topBlackGradient = GradientView(gradientColor: .black)
        return topBlackGradient
    }()
    
    
    init(viewModel: HomeViewModel) {
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
        let model = HomeViewModel(photosService: PhotosServiceImplementation())
        return [EditorialPage(viewModel: model)]
    }()
    
    
    //making navigation bar transparent
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationItem.titleView?.tintColor = .white
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.titleView = logoNameView
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
        view.addSubview(logoIconView)
        logoIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            $0.size.equalTo(20)
        }
        view.addSubview(topicBar)
        topicBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel(){
        // to update the topic bar and topic pages accordingly when topics are loaded
        viewModel.didLoadTopics = { [weak self] topics in
            self?.topicBar.updateTopics(
                with: topics.map({
                    let topic = Topic(
                        id: $0.id,
                        title: $0.title,
                        description: $0.topicDescription,
                        totalPhotos: $0.totalPhotos,
                        coverPhotoUrlString: $0.coverPhoto.urls.small)
                    self?.appendTopicPage(with: topic)
                    return topic
                })
            )}
    }
    
    private func appendTopicPage(with topic: Topic) {
        orderedSubViewControllers.append(
            TopicPage(
                viewModel: HomeViewModel(photosService: PhotosServiceImplementation()),
                topic: topic
            ))
    }
    
    private func fetchData() {
        viewModel.getAllTopics()
    }
    
    private func setUpMenuBar() {
        topicBar.didSelectBarItem = { [weak self] selectedIndex in
            guard let strongSelf = self else {
                return
            }
            let currentViewController = strongSelf.orderedSubViewControllers[selectedIndex]
            strongSelf.setViewControllers([currentViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    
    private func setUpInitialPage() {
        if let firstViewController = orderedSubViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
}





//MARK: - Change Pages When Swiped

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedSubViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex == 0 {
            return nil
        }
        
        return orderedSubViewControllers[viewControllerIndex - 1]
    }
    
    
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

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = orderedSubViewControllers.firstIndex(of: visibleViewController)
        {
            topicBar.chooseTopic(at: index)
        }
    }
    
}
