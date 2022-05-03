

import UIKit
import SnapKit

//MARK: - Scrollable and Choosable Topic Bar on Top

class TopicBar: UIView {
    
    // first topic is already set (Editorial)
    private var topics = [Topic(id: "", title: "Editorial", description: "", totalPhotos: 30, coverPhotoUrlString: "")] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var viewModel: HomeViewModel?
    
    // action when item selected
    var didSelectBarItem: ((Int) -> Void)?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    //initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setUpHorizontalBarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // updates topics with the first one selected
    func updateTopics(with topics: [Topic]) {
        self.topics.append(contentsOf: topics)
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .right)
    }
    
    
    // sets light gray horizonatal line as a scroll indicator line
    private func setUpHorizontalBarView() {
        let horizontalView = UIView()
        horizontalView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        addSubview(horizontalView)
        horizontalView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    
    // sets topics selected properly when swiped to specific position
    func chooseTopic(at position: Int){
        collectionView.selectItem(at: IndexPath(item: position, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}



//MARK: - Sets Topics Texts and Number of Topics

extension TopicBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicCell
        cell.setLabeltext(with: topics[indexPath.row].title)
        return cell
    }
}




//MARK: - Calls Action When Topic is Tapped

extension TopicBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectBarItem?(indexPath.row)
    }
}
