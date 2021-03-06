//
//  PhotoResultPage.swift
//  UnsplashPremium
//
//  Created by user on 10.05.2022.
//

import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout

class PhotoResultPage: UIViewController {
    
    private let viewModel: PhotoResultViewModel
    
    private var currentLastPage = 1
    
    private var query: String
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumInteritemSpacing = 4
        layout.itemRenderDirection = .shortestFirst
        layout.minimumColumnSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy private var noResultStackView: UIStackView = {
        let noResultStackView = UIStackView()
        noResultStackView.axis = .vertical
        noResultStackView.addArrangedSubview(noDataIcon)
        noResultStackView.addArrangedSubview(noPhotoLabel)
        return noResultStackView
    }()
    private let noDataIcon: UIImageView = {
        let image = UIImage(named: "noDataIcon")
        let noDataIcon = UIImageView(image: image)
        noDataIcon.contentMode = .scaleAspectFit
        return noDataIcon
    }()
    private let noPhotoLabel: UILabel = {
        let noPhotoLabel = UILabel()
        noPhotoLabel.font = .systemFont(ofSize: 17, weight: .bold)
        noPhotoLabel.textColor = .darkGray
        noPhotoLabel.textAlignment = .center
        noPhotoLabel.text = "No photos"
        return noPhotoLabel
    }()
    
    lazy private var collectionDirector: WaterfallCollectionDirector = {
        let collectionDirector = WaterfallCollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    init(with viewModel: PhotoResultViewModel, query: String){
        self.viewModel = viewModel
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        view.backgroundColor = UIColor(named: ColorKeys.background)
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().priority(999)
        }
    }
    
    private func layoutNoDataInfo() {
        noDataIcon.snp.makeConstraints{
            $0.size.equalTo(150)
        }
        view.addSubview(noResultStackView)
        noResultStackView.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
    private func bindViewModel(){
        viewModel.didLoadSearchedPhotos = { [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            if photos.isEmpty {
                strongSelf.layoutNoDataInfo()
            } else {
                strongSelf.collectionDirector.updateItems(with: photos.map { photo in
                    CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: photo),
                                       size: Size(width: strongSelf.view.frame.width,
                                                  height: strongSelf.view.frame.width/photo.aspectRatio))
                })
            }
        }
        viewModel.didLoadAdditionalSearchedPhotos = { [weak self] photos in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionDirector.addItems(with: photos.map { photo in
                CollectionCellData(cellConfigurator: HomePhotoCellConfigurator(data: photo),
                                   size: Size(width: strongSelf.view.frame.width/2.0,
                                              height: strongSelf.view.frame.width/2.0/photo.aspectRatio))
            })
        }
    }
    
    // request from service
    func fetchData() {
        viewModel.getSearchedPhotos(for: query, page: currentLastPage)
    }
    
    // show detail when cells are tapped
    private func setActionsForCells() {
        collectionDirector.actionProxy.on(action: .didReachedEnd) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentLastPage = strongSelf.currentLastPage + 1
            strongSelf.fetchData()
        }
        collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: HomePhotoCellConfigurator, cell) in
            let photo = configurator.data
            self?.navigationController?.pushViewController(
                PhotoDetailViewController(photo: photo),
                animated: true
            )
        }
    }
}
