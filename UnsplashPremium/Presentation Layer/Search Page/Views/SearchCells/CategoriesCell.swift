
import UIKit
import SnapKit

typealias CategoriesCellConfigurator = CollectionCellConfigurator<CategoriesCell, [Category]>


//MARK: - Photo Cell for Home Page


class CategoriesCell: UICollectionViewCell {
    
    private let viewModel = SearchViewModel(searchService: SearchServiceImplementation())

    static let identifier = "CategoriesCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setActionsForCells()
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
            
    private func setActionsForCells(){
        
    }

}



//MARK: - Set as Configurable Cell

extension CategoriesCell: ConfigurableCell {
    
    typealias DataType = [Category]
    
    func configure(data: [Category]) {
        self.collectionDirector.updateItemSizes(with: data.map({ _ in
            Size(width: (self.contentView.frame.height-10.0)/2.0, height: (self.contentView.frame.height-10.0)/2.0)
        }))
        
        self.collectionDirector.updateItems(with: data.map({
            CategoriesSubCellConfigurator(data: $0)
        }))
    }
}
