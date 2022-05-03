//
//  InfoPage.swift
//  UnsplashPremium
//
//  Created by user on 04.05.2022.
//

import UIKit
import SnapKit

class InfoPage: UIViewController {
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "Info"
        infoLabel.textColor = .white
        infoLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        return infoLabel
    }()
    
    private let cancelLabel: UILabel = {
        let cancelLabel = UILabel()
        cancelLabel.text = "Cancel"
        cancelLabel.textColor = .white
        cancelLabel.font = .systemFont(ofSize: 20, weight: .regular)
        return cancelLabel
    }()
    
    private let cameraLabel: UILabel = {
        let cameraLabel = UILabel()
        cameraLabel.text = "Camera"
        cameraLabel.textColor = .white
        cameraLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        return cameraLabel
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear.withAlphaComponent(0)
        return collectionView
    }()
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    private var data: [Info] = [Info(key: .make, value: "-"), Info(key: .focalLength, value: "-"), Info(key: .model, value: "-"), Info(key: .iso, value: "-"), Info(key: .shutterSpeed, value: "-"), Info(key: .dimensions, value: "-"), Info(key: .aperture, value: "-"), Info(key: .published, value: "-")]
    
    init(photoInfo: PhotoInfo) {
        super.init(nibName: nil, bundle: nil)
        data[0].value = photoInfo.exif.make
        data[1].value = photoInfo.exif.focalLength
        data[2].value = "\(photoInfo.exif.iso)"
        data[3].value = photoInfo.exif.exposureTime
        data[4].value = "\(photoInfo.dimensions.width)x\(photoInfo.dimensions.height)"
        data[5].value = photoInfo.exif.aperture
        data[6].value = photoInfo.publishedDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        collectionView.reloadData()
        collectionDirector.updateItems( with: data.map(){ InfoCellConfigurator(data: $0) })
        collectionDirector.updateItemSizes(with: data.map(){ _ in
            Size(width: (view.frame.width - 50.0) / 2.0, height: 40)
        })
        layout()
    }
    
    private func layout(){
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        view.addSubview(cancelLabel)
        cancelLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
        }
        view.addSubview(cameraLabel)
        cameraLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(cancelLabel.snp.bottom).offset(40)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(cameraLabel.snp.bottom).offset(20)
        }
    }
}

enum InfoKeys: String {
    case make = "Make"
    case focalLength = "Focal length"
    case model = "Model"
    case iso = "ISO"
    case shutterSpeed = "Shutter speed"
    case dimensions = "Dimensions"
    case aperture = "Aperture"
    case published = "Published"
}

struct Info {
    let key: InfoKeys
    var value: String
}
