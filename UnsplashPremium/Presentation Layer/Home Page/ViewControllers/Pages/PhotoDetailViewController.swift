
import UIKit
import SnapKit


//MARK: - Detail View of Image with More Quality

class PhotoDetailViewController: UIViewController {
    
    private var photoInfo: PhotoInfo?
    
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFit
        return photoView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let likeView: UIView = {
        let likeView = UIView()
        likeView.clipsToBounds = true
        likeView.backgroundColor = .darkGray
        return likeView
    }()
    private let likeImageView: UIImageView = {
        let likeImageView = UIImageView(image: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate))
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.tintColor = UIColor.white
        return likeImageView
    }()
    private let plusView: UIView = {
        let plusView = UIView()
        plusView.clipsToBounds = true
        plusView.backgroundColor = .darkGray
        return plusView
    }()
    private let plusImageView: UIImageView = {
        let plusImageView = UIImageView(image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate))
        plusImageView.contentMode = .scaleAspectFit
        plusImageView.tintColor = UIColor.white
        return plusImageView
    }()
    private let downloadView: UIView = {
        let downloadView = UIView()
        downloadView.clipsToBounds = true
        downloadView.backgroundColor = .white
        return downloadView
    }()
    private let downloadImageView: UIImageView = {
        let downloadImageView = UIImageView(image: UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate))
        downloadImageView.contentMode = .scaleAspectFit
        downloadImageView.tintColor = UIColor.darkGray
        return downloadImageView
    }()
    private let infoImageView: UIImageView = {
        let infoImageView = UIImageView(image: UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate))
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.tintColor = UIColor.white
        infoImageView.isUserInteractionEnabled = true
        return infoImageView
    }()
    
    
    //when info icon tapped: show photo info
    @objc private func infoIconTapped(){
        guard let photoInfo = photoInfo else {
            return
        }
        present(
            PhotoInfoViewController(photoInfo: photoInfo),
            animated: true,
            completion: nil
        )
    }
    
    //initialize
    init(photoUrlString: String, userName: String, photoId: String){
        super.init(nibName: nil, bundle: nil)
        setImage(with: photoUrlString)
        titleLabel.text = userName
        fetchData(with: photoId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.titleView = titleLabel
        
        infoImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(infoIconTapped)
            )
        )
        
        layout()
    }
    
    
    private func setImage(with urlString: String){
        PhotosServiceImplementation.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    
    // request for a single image
    private func fetchData(with id: String){
        PhotosServiceImplementation.getSinglePhoto(with: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInfo = PhotoInfo(
                    exif: data.exif,
                    dimensions: Size(
                        width: Double(data.width),
                        height: Double(data.height)
                    ),
                    publishedDate: data.createdAt
                )
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    
    
    private func layout(){
        view.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        layoutIcons()
    }
    
    private func layoutIcons(){
        layoutDownloadIcon()
        layoutPlusIcon()
        layoutLikeIcon()
        layoutInfoIcon()
    }
    
    private func layoutDownloadIcon(){
        view.addSubview(downloadView)
        downloadView.layer.cornerRadius = 25
        downloadView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
            $0.size.equalTo(50)
        }
        downloadView.addSubview(downloadImageView)
        downloadImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func layoutPlusIcon(){
        view.addSubview(plusView)
        plusView.layer.cornerRadius = downloadView.layer.cornerRadius
        plusView.snp.makeConstraints {
            $0.trailing.equalTo(downloadView)
            $0.bottom.equalTo(downloadView.snp.top).offset(-10)
            $0.size.equalTo(downloadView)
        }
        plusView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func layoutLikeIcon(){
        view.addSubview(likeView)
        likeView.layer.cornerRadius = downloadView.layer.cornerRadius
        likeView.snp.makeConstraints {
            $0.trailing.equalTo(downloadView)
            $0.bottom.equalTo(plusView.snp.top).offset(-10)
            $0.size.equalTo(downloadView)
        }
        likeView.addSubview(likeImageView)
        likeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func layoutInfoIcon(){
        view.addSubview(infoImageView)
        infoImageView.snp.makeConstraints {
            $0.bottom.equalTo(downloadView)
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().inset(10)
        }
    }
    
    
    // control tabbar appearance
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
        tabBarController?.tabBar.isHidden = true
    }
}
