//
//  SubmitToTopicViewController.swift
//  UnsplashPremium
//
//  Created by user on 16.05.2022.
//

import UIKit
import SnapKit

class SubmitToTopicViewController: UIViewController {
    
    private let topicTitle: UILabel = {
        let topicTitle = UILabel()
        topicTitle.textColor = .white
        topicTitle.font = .systemFont(ofSize: 20, weight: .bold)
        return topicTitle
    }()
    
    private let topicBottomLine: UIView = {
        let topicBottomLine = UIView()
        topicBottomLine.backgroundColor = .gray
        return topicBottomLine
    }()
    
    private let xButton: UIButton = {
        let xButton = UIButton()
        let image = UIImage(systemName: "x.circle.fill")
        xButton.setImage(image, for: .normal)
        xButton.backgroundColor = .clear
        xButton.tintColor = .gray
        xButton.addTarget(self, action: #selector(didTapX), for: .touchUpInside)
        return xButton
    }()
    
    private let aboutTitle: UILabel = {
        let aboutTitle = UILabel()
        aboutTitle.textColor = .white
        aboutTitle.text = "About"
        aboutTitle.font = .systemFont(ofSize: 18, weight: .bold)
        return aboutTitle
    }()

    private let titleDescriptionLabel: UILabel = {
        let titleDescriptionLabel = UILabel()
        titleDescriptionLabel.textColor = .lightGray
        titleDescriptionLabel.numberOfLines = 0
        titleDescriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return titleDescriptionLabel
    }()
    
    private let previewTitle: UILabel = {
        let previewTitle = UILabel()
        previewTitle.textColor = .white
        previewTitle.text = "Submissions from the community"
        previewTitle.font = .systemFont(ofSize: 18, weight: .bold)
        return previewTitle
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()
    
    private let submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.backgroundColor = .white
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.layer.cornerRadius = 5
        return submitButton
    }()

    @objc private func didTapX(){
        dismiss(animated: true, completion: nil)
    }
    init(topic: Topic){
        super.init(nibName: nil, bundle: nil)
        topicTitle.text = topic.title
        titleDescriptionLabel.text = topic.description
        guard let previewPhotos = topic.previewPhotos else { return }
        collectionDirector.updateItems(with: previewPhotos.map({ photo in
            CollectionCellData(cellConfigurator: PhotoCellConfigurator(data: photo.urls.small), size: Size(width: (self.view.frame.width-40.0)/4.0, height: (self.view.frame.width-40.0)/4.0))
        }))
        submitButton.setTitle("Submit to \(topic.title)", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layout()
        // Do any additional setup after loading the view.
    }
    
    private func layout(){
        view.addSubview(topicTitle)
        topicTitle.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(10)
            $0.height.equalTo(60)
        }
        view.addSubview(xButton)
        xButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(50)
            $0.centerY.equalTo(topicTitle)
        }
        view.addSubview(topicBottomLine)
        topicBottomLine.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(topicTitle.snp.bottom)
        }
        view.addSubview(aboutTitle)
        aboutTitle.snp.makeConstraints{
            $0.top.equalTo(topicBottomLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(40)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.bottom.equalTo(submitButton.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(view.frame.width/4.0)
        }
        view.addSubview(previewTitle)
        previewTitle.snp.makeConstraints{
            $0.bottom.equalTo(collectionView.snp.top).offset(-10)
            $0.leading.equalToSuperview().inset(10)
        }
        view.addSubview(titleDescriptionLabel)
        titleDescriptionLabel.snp.makeConstraints{
            $0.bottom.lessThanOrEqualTo(previewTitle.snp.top).offset(-10).priority(999)
            $0.top.equalTo(aboutTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
