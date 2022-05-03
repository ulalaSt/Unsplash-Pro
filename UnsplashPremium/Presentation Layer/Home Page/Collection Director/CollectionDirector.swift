
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
    
    private var itemSizes = [Size?]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
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
    
    func updateItemSizes(with newSizes: [Size?]){
        self.itemSizes = newSizes
    }
    
    func addItems(with newItems: [CellConfigurator]){
        self.items.append(contentsOf: newItems)
    }
    
    func addItemSizes(with newSizes: [Size?]){
        self.itemSizes.append(contentsOf: newSizes)
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
        
        if indexPath.row == self.items.count - 1 {
            DispatchQueue.main.async {
                CollectionAction.didReachedEnd.invoke(cell: collectionView.cellForItem(at: indexPath)!)
            }
        }
        
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
        
        if let size = itemSizes[indexPath.row] {
            let width = size.width
            let height = size.height
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
