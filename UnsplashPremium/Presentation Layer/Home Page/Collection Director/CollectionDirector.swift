
import UIKit
import SnapKit


//MARK: - Manages CollectionView

class CollectionDirector: NSObject {
    
    private let collectionView: UICollectionView
    
    let actionProxy = CollectionActionProxy()
    
    private var items = [CellConfigurator]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Photos For Everyone"
        welcomeLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        welcomeLabel.textColor = .white
        return welcomeLabel
    }()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(HomePagePhotoCell.self, forCellWithReuseIdentifier: HomePagePhotoCell.identifier)
        self.collectionView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(200)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(notification:)), name: CollectionAction.notificationName, object: nil)
    }
    
    @objc private func onActionEvent(notification: Notification) {
        if let eventData = notification.userInfo?["data"] as? CollectionActionEventData,
           let cell = eventData.cell as? UICollectionViewCell,
           let indexPath = self.collectionView.indexPath(for: cell)
        {
            actionProxy.invoke(action: eventData.action,
                               cell: cell,
                               configurator: self.items[indexPath.row])
        }
    }

    func updateItems(with newItems: [CellConfigurator]){
        self.items = newItems
    }
}




//MARK: - Sets Item Counts, and Configures Cells

extension CollectionDirector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        collectionView.register(type(of: item).cellClass, forCellWithReuseIdentifier: type(of: item).reuseId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
}



//MARK: - Calls Invoke When Item Is Selected

extension CollectionDirector: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         CollectionAction.didSelect.invoke(cell: collectionView.cellForItem(at: indexPath)!)
    }
}




//MARK: - Sets Item Size

extension CollectionDirector: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
