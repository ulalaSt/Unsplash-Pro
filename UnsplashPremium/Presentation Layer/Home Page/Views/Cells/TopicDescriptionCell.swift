
import UIKit
import SnapKit

typealias TopicDescriptionCellConfigurator = CollectionCellConfigurator<TopicDescriptionCell, Topic>

//MARK: - Photo Cell for Home Page

class TopicDescriptionCell: UICollectionViewCell {
    
    static let identifier = "TopicPagePhotoCell"
    
    private let topicLabel: UILabel = {
        let topicLabel = UILabel()
        topicLabel.textColor = .white
        topicLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        return topicLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 2
        return descriptionLabel
    }()
    
    private let addButton: UIButton = {
        let addButton = UIButton()
        addButton.setTitle("Submit a photo", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 4
        addButton.clipsToBounds = true
        return addButton
    }()
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = photoView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoView.addSubview(blurEffectView)
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
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(addButton.snp.top).offset(-10)
        }
        contentView.addSubview(topicLabel)
        topicLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
    }
}



//MARK: - Set as Configurable Cell

extension TopicDescriptionCell: ConfigurableCell {
    
    typealias DataType = Topic
    
    func configure(data: Topic) {
        self.topicLabel.text = data.title
        self.descriptionLabel.text = data.description
        setUpBlurredImage(with: data.coverPhotoUrlString)
    }
    
    // loads image by string url
    private func setUpBlurredImage(with urlString: String) {
        PhotosServiceImplementation.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
