
import UIKit
import SnapKit


//MARK: - Detail View of Image with More Quality

class PhotoDetailViewController: UIViewController {
    
    private let viewModel = PhotoDetailViewModel(photosService: PrivatePhotoServiceImplementation())
    
    private var photoInfo: PhotoInfo?
    
    private let initialLikedByUser: Bool
    
    private var likedByUser: Bool {
        didSet {
            checkLiked()
        }
    }
    private let photoId: String
    
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
        likeImageView.isUserInteractionEnabled = true
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
        downloadImageView.isUserInteractionEnabled = true
        return downloadImageView
    }()
    private let infoImageView: UIImageView = {
        let infoImageView = UIImageView(image: UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate))
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.tintColor = UIColor.white
        infoImageView.isUserInteractionEnabled = true
        return infoImageView
    }()
    
    private func checkLiked(){
        if likedByUser {
            likeImageView.tintColor = .systemRed
        }
        else {
            likeImageView.tintColor = .white
        }
    }
    
    @objc private func didTapShare(){
        guard let image = photoView.image else {
            return
        }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, isSent, _, _ in
            if isSent {
                print("Successfully sent")
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @objc private func didTapCancel(){
        _ = navigationController?.popViewController(animated: true)
        if initialLikedByUser != likedByUser {
            StoredData.inProcessChangedLikes[photoId] = likedByUser
            viewModel.photoLikeRequest(id: photoId, isLiked: likedByUser)
            NotificationCenter.default.post(name: NSNotification.Name("didChangeLike"), object: nil, userInfo: [photoId: likedByUser])
        }
    }
    
    @objc private func didTapLike(){
        likedByUser = !likedByUser
    }
    
    @objc private func didTapDownload(){
        guard let image = photoView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error on save!", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
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
    init(photo: Photo){
        self.photoId = photo.id
        if let likedInProcess = StoredData.inProcessChangedLikes[photoId]{
            likedByUser = likedInProcess
            initialLikedByUser = likedInProcess
        } else {
            initialLikedByUser = photo.details.likedByUser
            likedByUser = photo.details.likedByUser
        }
        super.init(nibName: nil, bundle: nil)
        checkLiked()
        setImage(with: photo.urlStringLarge)
        titleLabel.text = photo.userName
        fetchData(with: photo.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setNavigationItem()
        addGestures()
        layout()
    }
    private func addGestures(){
        infoImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(infoIconTapped)
            )
        )
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLike)))
        downloadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDownload)))
    }
    
    private func setNavigationItem() {
        navigationItem.titleView = titleLabel
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem?.tintColor = .white
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
