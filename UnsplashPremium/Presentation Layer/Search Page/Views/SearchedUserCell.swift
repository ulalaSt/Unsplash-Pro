
import UIKit
import SnapKit

typealias SearchedUserCellConfigurator = CollectionCellConfigurator<SearchedUserCell, UserWrapper>

//MARK: - Photo Cell for Home Page

class SearchedUserCell: UICollectionViewCell {
    
    static let identifier = "SearchedUserCell"
        
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 23, weight: .medium)
        authorLabel.textColor = .white
        return authorLabel
    }()
    
    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = .systemFont(ofSize: 15, weight: .regular)
        usernameLabel.textColor = .gray
        return usernameLabel
    }()

    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    private let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.layer.cornerRadius = 1
        bottomLine.clipsToBounds = true
        bottomLine.backgroundColor = .init(white: 0.3, alpha: 0.3)
        return bottomLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .init(white: 0.5, alpha: 0.2)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(contentView.frame.height*0.7)
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(photoView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview().inset(-authorLabel.frame.height)
        }
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(authorLabel)
            $0.top.equalTo(authorLabel.snp.bottom)
        }
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        DispatchQueue.main.async {
            self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        }
    }
}




//MARK: - Set as Configurable Cell

extension SearchedUserCell: ConfigurableCell {
    
    typealias DataType = UserWrapper
    
    func configure(data: UserWrapper) {
        self.authorLabel.text = data.name
        usernameLabel.text = data.username
        setUpImage(with: data.profileImageUrl.mediumImageUrl)
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
