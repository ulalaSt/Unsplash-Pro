
import UIKit
import SnapKit


//MARK: - Manages CollectionView

class CollectionDirector: NSObject {
    
    private let collectionView: UICollectionView
    
    let actionProxy = ActionProxy()
    
    private var items = [CollectionCellData]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(notification:)), name: Action.notificationName, object: nil)
    }
    
    @objc private func onActionEvent(notification: Notification) {
        if let eventData = notification.userInfo?["data"] as? ActionEventData,
           let cell = eventData.cell as? UICollectionViewCell,
           let indexPath = self.collectionView.indexPath(for: cell)
        {
            actionProxy.invoke(action: eventData.action,
                               cell: cell,
                               configurator: self.items[indexPath.row].cellConfigurator)
        }
    }

    func updateItems(with newItems: [CollectionCellData]){
        self.items = newItems
    }
        
    func addItems(with newItems: [CollectionCellData]){
        self.items.append(contentsOf: newItems)
    }
}




//MARK: - Sets Item Counts, and Configures Cells

extension CollectionDirector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        collectionView.register(type(of: item.cellConfigurator).cellClass, forCellWithReuseIdentifier: type(of: item.cellConfigurator).reuseId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item.cellConfigurator).reuseId, for: indexPath)
        item.cellConfigurator.configure(cell: cell)
        
        if indexPath.row == self.items.count - 1 {
            DispatchQueue.main.async {
                Action.didReachedEnd.invoke(cell: cell)
            }
        }
        
        return cell
    }
}



//MARK: - Calls Invoke When Item Is Selected

extension CollectionDirector: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         Action.didSelect.invoke(cell: collectionView.cellForItem(at: indexPath)!)
    }
}




//MARK: - Sets Item Size

extension CollectionDirector: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let size = items[indexPath.row].size {
            let width = size.width
            let height = size.height
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
