
import UIKit
import SnapKit

typealias SearchPageTitleCellConfigurator = CollectionCellConfigurator<SearchPageTitleCell, String>


//MARK: - Photo Cell for Home Page


class SearchPageTitleCell: UICollectionViewCell {
    
    private let viewModel = SearchViewModel(searchService: SearchServiceImplementation())

    static let identifier = "SearchPageTitleCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
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
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
            
    private func setActionsForCells(){
        
    }

}



//MARK: - Set as Configurable Cell

extension SearchPageTitleCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        label.text = data
    }
}
