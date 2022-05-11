
import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout

typealias CollectionContainingCellConfigurator = TableCellConfigurator<CollectionContainingCell, [Photo]>

//MARK: - Photo Cell for Home Page

class CollectionContainingCell: UITableViewCell {
    
    static let identifier = "CollectionContainingCell"
        
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.itemRenderDirection = .shortestFirst
        layout.minimumInteritemSpacing = 4.0
        layout.minimumColumnSpacing = 4.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private var photos: [Photo]?
    
    private lazy var collectionDirector: WaterfallCollectionDirector = {
        let collectionDirector = WaterfallCollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    private func layout(){
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func fetchData(){
        if let photos = photos {
            collectionDirector.updateItems(with:
                photos.map({
                CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: $0),
                                   size: Size(width: contentView.frame.width,
                                              height: contentView.frame.width/$0.aspectRatio))
                })
            )
        }
    }
    private func addActions(){
        collectionDirector.actionProxy.on(action: .didSelect) { (configurator: HomePhotoCellConfigurator, cell) in
            print(configurator.data)
        }
    }
}




//MARK: - Set as Configurable Cell

extension CollectionContainingCell: ConfigurableCell {
    
    typealias DataType = [Photo]
    
    func configure(data: [Photo]) {
        self.photos = data
        fetchData()
    }
}

