
import UIKit
import SnapKit


//MARK: - First Page for Top News

class EditorialPage: UIViewController {
    
    private let viewModel: HomePageViewModel
    
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Photos For Everyone"
        welcomeLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        welcomeLabel.textColor = .white
        return welcomeLabel
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
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
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading Data...", attributes: attributes)
        refreshControl.layer.zPosition = -1
        return refreshControl
    }()

    // to refresh collectionView
    @objc private func reloadCollection(){
        self.collectionView.refreshControl?.beginRefreshing()
        self.fetchData()
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    // initializer
    init(viewModel: HomePageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
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
        collectionView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
    }
    
    // to reload collectionView with Editorial images
    private func bindViewModel(){
        viewModel.didLoadEditorialPhotos = { [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionDirector.updateItems(with: photos.map({ photo in
                CollectionCellData(
                    cellConfigurator: HomePhotoCellConfigurator( data: Photo(wrapper: photo)),
                    size: Size(
                        width: strongSelf.view.frame.width,
                        height: strongSelf.view.frame.width * Double(photo.height) / Double(photo.width)
                    ))
            }))
        }
    }
    
    // request from service
    private func fetchData() {
        viewModel.getEditorialPhotos()
        
    }
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        self.collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photo = configurator.data
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(photo: photo),
                animated: true
            )
        }
    }
}
