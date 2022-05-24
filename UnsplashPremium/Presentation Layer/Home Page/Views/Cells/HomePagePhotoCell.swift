
import UIKit
import SnapKit

typealias HomePhotoCellConfigurator = CollectionCellConfigurator<HomePagePhotoCell, Photo>

//MARK: - Photo Cell for Home Page

class HomePagePhotoCell: UICollectionViewCell {
    
    private let viewModel = PhotoDetailViewModel(photosService: PrivatePhotoServiceImplementation())

    static let identifier = "HomePagePhotoCell"
    
    private var isLiked = false {
        didSet {
            checkLiked()
        }
    }
    
    private func checkLiked(){
        if isLiked {
            likeButton.tintColor = .white
            likeButton.backgroundColor = .systemRed
        }
        else {
            likeButton.tintColor = .black
            likeButton.backgroundColor = .white
        }
    }


    private var photoID: String!

    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        return authorLabel
    }()
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.isUserInteractionEnabled = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    private let plusButton: UIButton = {
        let plusButton = UIButton()
        let image = UIImage(systemName: "plus")
        plusButton.setImage(image, for: .normal)
        plusButton.tintColor = .black
        plusButton.backgroundColor = .white
        plusButton.layer.cornerRadius = 25
        plusButton.clipsToBounds = true
        plusButton.isHidden = true
        return plusButton
    }()
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        let image = UIImage(systemName: "heart.fill")
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = .black
        likeButton.backgroundColor = .white
        likeButton.layer.cornerRadius = 25
        likeButton.clipsToBounds = true
        likeButton.isHidden = true
        return likeButton
    }()
    private let tappedlikeButton: UIButton = {
        let tappedlikeButton = UIButton()
        let image = UIImage(systemName: "heart.fill")
        tappedlikeButton.setImage(image, for: .normal)
        tappedlikeButton.tintColor = .red
        tappedlikeButton.backgroundColor = .clear
        tappedlikeButton.layer.cornerRadius = 25
        tappedlikeButton.clipsToBounds = true
        tappedlikeButton.isHidden = true
        return tappedlikeButton
    }()
    private let downloadButton: UIButton = {
        let downloadButton = UIButton()
        let image = UIImage(systemName: "arrow.down")
        downloadButton.setImage(image, for: .normal)
        downloadButton.tintColor = .black
        downloadButton.backgroundColor = .white
        downloadButton.layer.cornerRadius = 25
        downloadButton.clipsToBounds = true
        downloadButton.isHidden = true
        return downloadButton
    }()
    private let tappedDownloadButton: UIButton = {
        let tappedDownloadButton = UIButton()
        let image = UIImage(systemName: "arrow.down")
        tappedDownloadButton.setImage(image, for: .normal)
        tappedDownloadButton.tintColor = .black
        tappedDownloadButton.backgroundColor = .white
        tappedDownloadButton.layer.cornerRadius = 25
        tappedDownloadButton.clipsToBounds = true
        tappedDownloadButton.isHidden = true
        return tappedDownloadButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressLong(gesture:)))
        gesture.minimumPressDuration = 0.5
        contentView.addGestureRecognizer(gesture)
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
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        contentView.addSubview(tappedlikeButton)
        tappedlikeButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        contentView.addSubview(downloadButton)
        downloadButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        contentView.addSubview(tappedDownloadButton)
        tappedDownloadButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }

    }
    var locationAtBeginning: CGPoint?

    @objc private func didPressLong(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let location = gesture.location(in: self.superview)
            locationAtBeginning = location
            animateAllButtons(from: location)
        } else if gesture.state == .changed {
            checkButtonInside(button: plusButton, gesture: gesture)
            checkButtonInside(button: likeButton, gesture: gesture)
            checkButtonInside(button: downloadButton, gesture: gesture)
        } else if gesture.state == .ended {
            guard let locationAtBeginning = locationAtBeginning else {
                return
            }
            checkButtonForDownload(gesture: gesture)
            checkButtonForLike(gesture: gesture)
            animateAllButtons(from: locationAtBeginning, backwards: true)
        }
    }
    private func checkButtonForLike(gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: likeButton)
        if likeButton.point(inside: location, with: nil) {
            tappedlikeButton.center = likeButton.center
            tappedlikeButton.isHidden = false
            tappedlikeButton.alpha = 1
            UIButton.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.tappedlikeButton.center = CGPoint(x: self.tappedlikeButton.frame.midX, y: self.tappedlikeButton.frame.midY - 50)
                self.tappedlikeButton.alpha = 0
            }) { _ in
                self.tappedlikeButton.isHidden = true
                self.didTapLike()
            }
        }
    }
    private func checkButtonForDownload(gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: downloadButton)
        if downloadButton.point(inside: location, with: nil) {
            tappedDownloadButton.center = downloadButton.center
            tappedDownloadButton.isHidden = false
            tappedDownloadButton.alpha = 1
            didTapDownload()
        }
    }
    private func didTapDownload(){
        guard let image = photoView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(String(describing: error))
        } else {
            UIButton.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.tappedDownloadButton.center = CGPoint(x: self.tappedDownloadButton.frame.midX-10, y: self.tappedDownloadButton.frame.midY - 10)
            }) { finished in
                if finished {
                    UIButton.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                        self.tappedDownloadButton.center = CGPoint(x: self.tappedDownloadButton.frame.midX-10, y: self.tappedDownloadButton.frame.midY + 80)
                        self.tappedDownloadButton.alpha = 0
                    }) { finished in
                        if finished {
                            self.tappedDownloadButton.isHidden = true
                        }
                    }
                }
            }
        }
    }

    private func didTapLike(){
        isLiked = !isLiked
        StoredData.inProcessChangedLikes[photoID] = isLiked
        viewModel.photoLikeRequest(id: photoID, isLiked: isLiked)
        NotificationCenter.default.post(name: NSNotification.Name("didChangeLike"), object: nil, userInfo: [photoID: isLiked])
    }
    private func animateAllButtons(from location: CGPoint, backwards: Bool = false) {
        guard let parentView = self.superview as? UICollectionView else {
            return
        }
        self.superview?.bringSubviewToFront(self)
        if location.x > 75 && location.x < (parentView.frame.maxX - 75.0) {
            animateButton(button: plusButton, from: location, xBy: 0, yBy: -40, backwards: backwards)
            animateButton(button: likeButton, from: location, xBy: 50, yBy: 0, backwards: backwards)
            animateButton(button: downloadButton, from: location, xBy: -50, yBy: 0, backwards: backwards)
        } else if location.x < 75 {
            var newLocation = location
            if location.x < 25 {
                newLocation.x = 25
            }
            animateButton(button: plusButton, from: newLocation, xBy: 40, yBy: 0, backwards: backwards)
            animateButton(button: likeButton, from: newLocation, xBy: 0, yBy: 50, backwards: backwards)
            animateButton(button: downloadButton, from: newLocation, xBy: 0, yBy: -50, backwards: backwards)
        } else {
            var newLocation = location
            if location.x > (parentView.frame.maxX - 25) {
                newLocation.x = parentView.frame.maxX - 25
            }
            animateButton(button: plusButton, from: newLocation, xBy: -40, yBy: 0, backwards: backwards)
            animateButton(button: likeButton, from: newLocation, xBy: 0, yBy: 50, backwards: backwards)
            animateButton(button: downloadButton, from: newLocation, xBy: 0, yBy: -50, backwards: backwards)
        }
    }
    private func checkButtonInside(button: UIButton, gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: button)
        if button.point(inside: location, with: nil) {
            UIButton.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                button.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        } else {
            button.transform = CGAffineTransform.identity
        }
    }
    private func animateButton(button: UIButton, from pointOnSuperView: CGPoint, xBy: Double, yBy: Double, backwards: Bool) {
        let point = CGPoint(x: pointOnSuperView.x-self.frame.origin.x, y: pointOnSuperView.y-self.frame.origin.y)
        if backwards {
            UIButton.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                button.center = point
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }) { _ in
                button.isHidden = true
            }
        } else {
            button.isHidden = false
            button.center = point
            button.alpha = 0
            button.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIButton.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                button.alpha = 1.0;
                button.transform = .identity
                button.center = CGPoint(x: point.x + xBy, y: point.y + yBy)
            }, completion: nil)
        }
    }

}




//MARK: - Set as Configurable Cell

extension HomePagePhotoCell: ConfigurableCell {
    
    typealias DataType = Photo
    
    func configure(data: Photo) {
        self.photoID = data.id
        if let likedInProcess = StoredData.inProcessChangedLikes[data.id]{
            isLiked = likedInProcess
        } else {
            isLiked = data.details.likedByUser
        }
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
