
import UIKit
import SnapKit



class CollectionDetailViewController: UIViewController {
    
    private let viewModel: CollectionDetailViewModel
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let topBlackGradient: GradientView = {
        let topBlackGradient = GradientView(gradientColor: .black)
        return topBlackGradient
    }()
    
    private var currentLastPage = 1
    
    private let id: String
    
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
    
    // initialize with specific topic
    init(viewModel: CollectionDetailViewModel, title: String, id: String) {
        self.viewModel = viewModel
        self.titleLabel.text = title
        self.id = id
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.titleView = titleLabel

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
        view.addSubview(topBlackGradient)
        topBlackGradient.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(65)
        }
    }
    
    // to reload collectionView with topic related images
    private func bindViewModel(){
        viewModel.didLoadCollectionPhotos = { [weak self] photos in
            
            guard let strongSelf = self else {
                return
            }
            var items: [CollectionCellData] = []
            
            items.append(contentsOf: photos.map({ photo in
                CollectionCellData(
                    cellConfigurator: HomePhotoCellConfigurator( data: photo),
                    size: Size(
                        width: strongSelf.view.frame.width,
                        height: strongSelf.view.frame.width/photo.aspectRatio)
                )
            }))
            self?.collectionDirector.updateItems(with: items)
        }
        
        viewModel.didLoadAdditionalCollectionPhotos = { [weak self] photos in
            
            guard let strongSelf = self else {
                return
            }
            var items: [CollectionCellData] = []
            
            items.append(contentsOf: photos.map({ photo in
                CollectionCellData(
                    cellConfigurator: HomePhotoCellConfigurator( data: photo),
                    size: Size(
                        width: strongSelf.view.frame.width,
                        height: strongSelf.view.frame.width/photo.aspectRatio)
                )
            }))
            self?.collectionDirector.addItems(with: items)
        }
    }
    
    
    // initial request from service
    private func fetchData() {
        viewModel.getSearchedCollections(id: self.id, page: 1)
    }
    
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photo = configurator.data
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(photo: photo),
                animated: true
            )
        }
        
//        collectionDirector.actionProxy.on(action: .didReachedEnd) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
//            guard let strongSelf = self else {
//                return
//            }
//            if strongSelf.currentLastPage * 10 < strongSelf.topic.totalPhotos {
//                strongSelf.currentLastPage = strongSelf.currentLastPage + 1
//                strongSelf.fetchData()
//            }
//        }
    }
}

