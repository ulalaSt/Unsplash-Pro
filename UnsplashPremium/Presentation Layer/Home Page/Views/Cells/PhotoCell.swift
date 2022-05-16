
import UIKit
import SnapKit

typealias PhotoCellConfigurator = CollectionCellConfigurator<PhotoCell, String>

//MARK: - Photo Cell for Home Page

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
        
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
    }
}




//MARK: - Set as Configurable Cell

extension PhotoCell: ConfigurableCell {
    
    typealias DataType = String
    
    func configure(data: String) {
        setUpImage(with: data)
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
