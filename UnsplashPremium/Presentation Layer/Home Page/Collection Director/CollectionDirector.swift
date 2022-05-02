//
//  TableDirector.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//
import UIKit
import SnapKit

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
        return welcomeLabel
    }()
            
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(HomePhotoCell.self, forCellWithReuseIdentifier: HomePhotoCell.identifier)
        
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

extension CollectionDirector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        collectionView.register(type(of: item).cellClass, forCellWithReuseIdentifier: type(of: item).reuseId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        cell.layoutIfNeeded()
        if cell.frame.size.width != collectionView.frame.size.width {
           cell.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: cell.frame.size.height)
           cell.layoutIfNeeded()
          }
        item.configure(cell: cell)
        return cell
    }
}

extension CollectionDirector: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         CollectionAction.didSelect.invoke(cell: collectionView.cellForItem(at: indexPath)!)

    }
}

extension CollectionDirector: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
