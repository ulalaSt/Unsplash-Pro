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
    
    private var items = [Photo]() {
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
    }
        
    func updateItems(with newItems: [Photo]){
        self.items = newItems
    }
}

extension CollectionDirector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhotoCell.identifier, for: indexPath) as! HomePhotoCell
        let item = items[indexPath.row]
        cell.configure(text: item.userName, imageUrlString: item.urlStringSmall)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let configurator = items[indexPath.row]
//        tableView.register(type(of: configurator).cellClass, forCellReuseIdentifier: type(of: configurator).identifier)
//        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: configurator).identifier, for: indexPath)
//        configurator.configure(cell: cell)
//        return cell
//    }
}

extension CollectionDirector: UICollectionViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        Action.didSelect.invoke(cell: tableView.cellForRow(at: indexPath)!)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let configurator = items[indexPath.row]
//        return type(of: configurator).heightForRow
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Top News"
//    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.textLabel?.font = UIFont(name: "NewYorkMedium-Bold", size: 30)
//        header.textLabel?.frame = header.bounds
//    }
}

extension CollectionDirector: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
