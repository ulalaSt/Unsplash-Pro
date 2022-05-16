//
//  PostViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit

class PostViewController: UIViewController {
    
    private let viewModel: PostViewModel
    
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.text = "Contribute to Unsplash"
        topLabel.font = .systemFont(ofSize: 30, weight: .bold)
        topLabel.textColor = .white
        return topLabel
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        return tableDirector
    }()
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layout()
        setCells()
        bindViewModel()
        fetchData()
        setCellActions()
    }
    
    private func layout(){
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(topLabel.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setCells(){
        tableDirector.updateItems(
            with:
                [
                    TableCellData(configurator: UploadPhotoCellConfigurator(item: "Upload your photo to the largest library of open photography"), height: 250),
                    TableCellData(
                        configurator:
                            TitleRecommendationCellConfigurator(
                                item: TitleCellData( text: "Submit to topics",
                                                     textFont: .systemFont(ofSize: 20, weight: .bold))),
                        height: 60)
                ])
    }
    
    private func bindViewModel(){
        viewModel.didLoadTopics = { topics in
            self.tableDirector.addItems(with: [TableCellData(configurator: SubmitToTopicCellConfigurator(item: topics.map({
                Topic(id: $0.id, title: $0.title, description: $0.topicDescription, totalPhotos: $0.totalPhotos, coverPhotoUrlString: $0.coverPhoto.urls.small, previewPhotos: $0.previewPhotos)
            })), height: 250)])
        }
    }
    
    private func fetchData(){
        viewModel.getAllTopics()
    }
    
    private func setCellActions(){
        tableDirector.actionProxy.on(action: .custom("categorySelected")) { [weak self] (configurator: SubmitToTopicCellConfigurator, cell) in
            guard let strongSelf = self, let topic = cell.tappedSearchedCollectionCellConfigurator?.data else {
                return
            }
            
            let viewController = SubmitToTopicViewController(topic: topic)
            if let presentationController = viewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()] /// change to [.medium(), .large()] for a half *and* full screen sheet
            }

            strongSelf.present(viewController, animated: true, completion: nil)

            
        }
    }
}
