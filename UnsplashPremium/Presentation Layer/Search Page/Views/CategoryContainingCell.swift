
import UIKit
import SnapKit

typealias CategoryContainingCellConfigurator = TableCellConfigurator<CategoryContainingCell, [Category]>

//MARK: - Photo Cell for Home Page

class CategoryContainingCell: UITableViewCell {
    
    static let identifier = "CategoryContainingCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private var categories: [Category]?
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func fetchData(){
        if let categories = categories {
            collectionDirector.updateItems(with: categories.map({
                CollectionCellData(
                    cellConfigurator:
                        SearchedCollectionCellConfigurator(
                            data: Collection(id: "",
                                             title: $0.title,
                                             smallUrl: $0.imageUrl,
                                             regularUrl: $0.imageUrl)),
                    size: Size(width: (contentView.frame.height-10.0)/2.0,
                               height: (contentView.frame.height-10.0)/2.0))
            }))
        }
    }
    
    var tappedSearchedCollectionCellConfigurator: SearchedCollectionCellConfigurator?
    
    private func setActions(){
        collectionDirector.actionProxy.on(action: .didSelect) { (configurator: SearchedCollectionCellConfigurator, cell) in
            self.tappedSearchedCollectionCellConfigurator = configurator
            Action.custom("categorySelected").invoke(cell: self)
        }
    }
}




//MARK: - Set as Configurable Cell

extension CategoryContainingCell: ConfigurableCell {
    
    typealias DataType = [Category]
    
    func configure(data: [Category]) {
        self.categories = data
        fetchData()
    }
}

