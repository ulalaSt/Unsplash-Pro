
import UIKit
import SnapKit


//MARK: - First Page for Top News

class EditorialPage: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Photos For Everyone"
        welcomeLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        welcomeLabel.textColor = .white
        return welcomeLabel
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    
    // to add pull to refresh functionality
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadCollection), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading Data...", attributes: attributes)
        refreshControl.layer.zPosition = -1
        return refreshControl
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

    // to refresh collectionView
    @objc private func reloadCollection(){
        self.collectionView.refreshControl?.beginRefreshing()
        self.fetchData()
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    
    // initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressLong(gesture:)))
        gesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(gesture)

        collectionView.refreshControl = self.refreshControl
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        view.addSubview(tappedlikeButton)
        tappedlikeButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints{
            $0.size.equalTo(50)
        }
    }
    var locationAtBeginning: CGPoint?

    @objc private func didPressLong(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let location = gesture.location(in: self.view)
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
                self.didTapLike(at: gesture.location(in: self.collectionView))
            }
        }
    }
    private func didTapLike(at position: CGPoint){
        if let indexPath = collectionView.indexPathForItem(at: position), let cell = collectionView.cellForItem(at: indexPath) as? HomePagePhotoCell {
            
        }
        
    }
    private func animateAllButtons(from location: CGPoint, backwards: Bool = false) {
        if location.x > 75 && location.x < (view.frame.maxX - 75.0) {
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
            if location.x > (view.frame.maxX - 25) {
                newLocation.x = view.frame.maxX - 25
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
    private func animateButton(button: UIButton, from point: CGPoint, xBy: Double, yBy: Double, backwards: Bool) {
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
    
    // to reload collectionView with Editorial images
    private func bindViewModel(){
        viewModel.didLoadEditorialPhotos = { [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.collectionDirector.updateItems(with: photos.map({ photo in
                CollectionCellData(
                    cellConfigurator: HomePhotoCellConfigurator( data: Photo(wrapper: photo)),
                    size: Size(
                        width: strongSelf.view.frame.width,
                        height: strongSelf.view.frame.width * Double(photo.height) / Double(photo.width)
                    ))
            }))
        }
    }
    
    
    // request from service
    private func fetchData() {
        viewModel.getEditorialPhotos()
        
    }
    
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        self.collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photo = configurator.data
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(photo: photo),
                animated: true
            )
        }
    }
}
