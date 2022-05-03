
import UIKit
import SnapKit


//MARK: - Additional Pages for Top News of Specific Topics

class TopicPage: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let topic: Topic
    
    private var currentLastPage = 1
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    // to add pull to refresh functionality
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadCollection), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading Data...", attributes: attributes)
        refreshControl.layer.zPosition = -1
        return refreshControl
    }()
    
    
    // to refresh collectionView
    @objc private func reloadCollection(){
        self.collectionView.refreshControl?.beginRefreshing()
        currentLastPage = 1
        self.fetchData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    // initialize with specific topic
    init(viewModel: HomeViewModel, topic: Topic) {
        self.viewModel = viewModel
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        collectionView.refreshControl = self.refreshControl
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    // to reload collectionView with topic related images
    private func bindViewModel(){
        viewModel.didLoadPhotosForTopic = { [weak self] photos in

            guard let strongSelf = self else {
                return
            }
            
            var items: [CellConfigurator] = [TopicDescriptionCellConfigurator(data: strongSelf.topic)]
            var itemSizes: [Size?] = [nil]
            
            itemSizes.append(contentsOf: photos.map({ photo in
                Size(
                    width: strongSelf.view.frame.width,
                    height: strongSelf.view.frame.width * Double(photo.height) / Double(photo.width))
            }))
            
            strongSelf.collectionDirector.updateItemSizes(with: itemSizes)
            items.append(contentsOf: photos.map({ photo in
                HomePhotoCellConfigurator(
                    data: Photo(
                        id: photo.id,
                        urlStringSmall: photo.urls.small,
                        urlStringLarge: photo.urls.regular,
                        userName: photo.user.name,
                        details: PhotoDetail(
                            color: photo.color,
                            created_at: photo.createdAt,
                            name: photo.user.name,
                            blurHash: photo.blurHash)))
            }))
            self?.collectionDirector.updateItems(with: items)
        }
        
        viewModel.didLoadAdditionalPhotosForTopic = { [weak self] photos in
            guard let strongSelf = self else {
                return
            }

            strongSelf.collectionDirector.addItemSizes(with: photos.map({ photo in
                Size(
                    width: strongSelf.view.frame.width,
                    height: strongSelf.view.frame.width * Double(photo.height) / Double(photo.width))
            }))
            strongSelf.collectionDirector.addItems(with: photos.map({ photo in
                HomePhotoCellConfigurator(
                    data: Photo(
                        id: photo.id,
                        urlStringSmall: photo.urls.small,
                        urlStringLarge: photo.urls.regular,
                        userName: photo.user.name,
                        details: PhotoDetail(
                            color: photo.color,
                            created_at: photo.createdAt,
                            name: photo.user.name,
                            blurHash: photo.blurHash)))
            }))
        }
    }
    
    
    // initial request from service
    private func fetchData() {
        viewModel.getPhotosFor(topic: self.topic, page: currentLastPage)
    }
    
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photoUrl = configurator.data.urlStringLarge
            let userName = configurator.data.userName
            let id = configurator.data.id
            self?.navigationController?.pushViewController(DetailPage(photoUrlString: photoUrl, userName: userName, photoId: id), animated: true)
        }
        
        collectionDirector.actionProxy.on(action: .didReachedEnd) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.currentLastPage * 10 < strongSelf.topic.totalPhotos {
                strongSelf.currentLastPage = strongSelf.currentLastPage + 1
                strongSelf.fetchData()
            }
        }
    }
}

