
import UIKit
import SnapKit

typealias TopicPhotoCellConfigurator = CollectionCellConfigurator<TopicPhotoCell, Topic>

//MARK: - Photo Cell for Home Page

class TopicPhotoCell: UICollectionViewCell {
    
    static let identifier = "TopicPhotoCell"
        
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        authorLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return authorLabel
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 15
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}




//MARK: - Set as Configurable Cell

extension TopicPhotoCell: ConfigurableCell {
    
    typealias DataType = Topic
    
    func configure(data: Topic) {
        self.authorLabel.text = data.title
        setUpImage(with: data.coverPhotoUrlString)
    }
    
    // loads image by string url
    private func setUpImage(with urlString: String) {
        PhotosServiceImplementation.getImage(urlString: urlString) { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    
}
