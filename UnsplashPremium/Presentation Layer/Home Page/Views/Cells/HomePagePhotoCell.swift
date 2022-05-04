
import UIKit
import SnapKit

typealias HomePhotoCellConfigurator = CollectionCellConfigurator<HomePagePhotoCell, Photo>

//MARK: - Photo Cell for Home Page

class HomePagePhotoCell: UICollectionViewCell {
    
    static let identifier = "HomePagePhotoCell"
        
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        return authorLabel
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
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
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }
}




//MARK: - Set as Configurable Cell

extension HomePagePhotoCell: ConfigurableCell {
    
    typealias DataType = Photo
    
    func configure(data: Photo) {
        self.authorLabel.text = data.userName
        configurePlaceHolder(with: data.details.color)
        setUpImage(with: data.urlStringSmall)
    }
    
    
    // sets appropriate color as placeholder before images are loaded
    private func configurePlaceHolder(with hexString: String) {
        
        let redIndex = hexString.index(hexString.startIndex, offsetBy: 1)
        let greenIndex = hexString.index(hexString.startIndex, offsetBy: 3)
        let blueIndex = hexString.index(hexString.endIndex, offsetBy: -2)
        
        self.backgroundColor = UIColor(
            red: CGFloat(Float(String(hexString[redIndex..<greenIndex])) ?? 0),
            green: CGFloat(Float(String(hexString[greenIndex..<blueIndex])) ?? 0),
            blue: CGFloat(Float(String(hexString[blueIndex..<hexString.endIndex])) ?? 0),
            alpha: 0.8)
        
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
