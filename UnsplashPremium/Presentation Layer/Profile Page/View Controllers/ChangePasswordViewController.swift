//
//  EditProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import UIKit
import SnapKit
import SafariServices

class ChangePasswordViewController: UIViewController {
    
    private let profileTableView: ResizableTableView = {
        let profileTableView = ResizableTableView()
        profileTableView.layer.cornerRadius = 10
        profileTableView.isScrollEnabled = false
        profileTableView.clipsToBounds = true
        return profileTableView
    }()
    
    private lazy var profileTableDirector: TableDirector = {
        let profileTableDirector = TableDirector(tableView: profileTableView)
        return profileTableDirector
    }()
        
    private let warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.text = "WARNING"
        warningLabel.textColor = .lightGray
        warningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return warningLabel
    }()
    
    private let warningTextLabel: UILabel = {
        let warningTextLabel = UILabel()
        warningTextLabel.text = "Changing password is not possible in this app. API does not allow to do so since it is extremely private action. In any case, you can do it on Unsplash Browser."
        warningTextLabel.numberOfLines = 0
        warningTextLabel.textColor = .white
        warningTextLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return warningTextLabel
    }()

    private let editFullLabel: UILabel = {
        let editFullLabel = UILabel()
        editFullLabel.text = "Edit your full information on "
        editFullLabel.textColor = .lightGray
        editFullLabel.font = .systemFont(ofSize: 16, weight: .regular)
        editFullLabel.sizeToFit()
        return editFullLabel
    }()
    
    private let linkLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.text = "unsplash.com"
        linkLabel.textColor = .white
        linkLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        linkLabel.sizeToFit()
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLinkLabel)))
        return linkLabel
    }()
    
    @objc private func didTapLinkLabel() {
        let url = "https://unsplash.com"
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.estimatedRowHeight = 50
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem = cancelButton
        view.backgroundColor = .darkGray
        layout()
        setTableData()
        bindViewModel()
        setActions()
    }
    
    private var thingsToChange: [ThingsToChange:String] = [:]
    
    @objc private func didTapSave(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapCancel(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func layout(){
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(profileTableView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(warningTextLabel)
        warningTextLabel.snp.makeConstraints {
            $0.top.equalTo(warningLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        view.addSubview(editFullLabel)
        editFullLabel.snp.makeConstraints{
            $0.top.equalTo(warningTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        view.addSubview(linkLabel)
        linkLabel.snp.makeConstraints{
            $0.centerY.equalTo(editFullLabel)
            $0.leading.equalTo(editFullLabel.snp.trailing)
        }
    }
    
    private func setTableData() {
        profileTableDirector.updateItems(with: [
            TableCellData(
                configurator:
                    TextFieldSimpleCellConfigurator(
                        item:
                            TextFieldSimpleData(
                                text: nil,
                                placeHolder: "Current Password")),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldSimpleCellConfigurator(
                        item:
                            TextFieldSimpleData(
                                text: nil,
                                placeHolder: "New Password")),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldSimpleCellConfigurator(
                        item:
                            TextFieldSimpleData(
                                text: nil,
                                placeHolder: "Confirm New Password")),
                height: 50),
        ])
    }
    private func bindViewModel(){
    }
    private func setActions(){
    }
}
