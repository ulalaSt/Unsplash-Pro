
import UIKit
import SnapKit

typealias SubmitToTopicCellConfigurator = TableCellConfigurator<SubmitToTopicCell, [Topic]>

//MARK: - Photo Cell for Home Page

class SubmitToTopicCell: UITableViewCell {
    
    static let identifier = "SubmitToTopicCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private var topics: [Topic]?
    
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
        if let topics = topics {
            collectionDirector.updateItems(with: topics.map({
                CollectionCellData(
                    cellConfigurator:
                        TopicPhotoCellConfigurator(data: $0),
                    size: Size(width: (contentView.frame.width-50.0)/2.0,
                               height: (contentView.frame.height-10.0)/2.0))
            }))
        }
    }
    
    var tappedSearchedCollectionCellConfigurator: TopicPhotoCellConfigurator?
    
    private func setActions(){
        collectionDirector.actionProxy.on(action: .didSelect) { (configurator: TopicPhotoCellConfigurator, cell) in
            self.tappedSearchedCollectionCellConfigurator = configurator
            Action.custom("categorySelected").invoke(cell: self)
        }
    }
}




//MARK: - Set as Configurable Cell

extension SubmitToTopicCell: ConfigurableCell {
    
    typealias DataType = [Topic]
    
    func configure(data: [Topic]) {
        self.topics = data
        fetchData()
    }
}

