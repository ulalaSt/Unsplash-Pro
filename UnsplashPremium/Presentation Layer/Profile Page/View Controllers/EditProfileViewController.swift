//
//  EditProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import UIKit
import SnapKit
import SafariServices

class EditProfileViewController: UIViewController {
    
    private let userProfile: UserProfileWrapper
    
    private let viewModel: EditProfileViewModel
    
    private let profileLabel: UILabel = {
        let profileLabel = UILabel()
        profileLabel.text = "PROFILE"
        profileLabel.textColor = .lightGray
        profileLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return profileLabel
    }()
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
    
    private let aboutLabel: UILabel = {
        let aboutLabel = UILabel()
        aboutLabel.text = "ABOUT"
        aboutLabel.textColor = .lightGray
        aboutLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return aboutLabel
    }()
    
    private let aboutTableView: ResizableTableView = {
        let aboutTableView = ResizableTableView()
        aboutTableView.layer.cornerRadius = 10
        aboutTableView.isScrollEnabled = false
        aboutTableView.clipsToBounds = true
        return aboutTableView
    }()
    
    private lazy var aboutTableDirector: TableDirector = {
        let aboutTableDirector = TableDirector(tableView: aboutTableView)
        return aboutTableDirector
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
    
    init(profile: UserProfileWrapper, viewModel: EditProfileViewModel){
        self.userProfile = profile
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.estimatedRowHeight = 50
        aboutTableView.estimatedRowHeight = 50
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem = cancelButton
        view.backgroundColor = UIColor(named: ColorKeys.presentationBackground)
        layout()
        setTableData()
        bindViewModel()
        setActions()
    }
    
    private var thingsToChange: [ThingsToChange:String] = [:]
    
    @objc private func didTapSave(){
        viewModel.postUpdatedUserProfile(with: thingsToChange)
    }
    
    @objc private func didTapCancel(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func layout(){
        view.addSubview(profileLabel)
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        view.addSubview(aboutLabel)
        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(profileTableView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(aboutTableView)
        aboutTableView.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        view.addSubview(editFullLabel)
        editFullLabel.snp.makeConstraints{
            $0.top.equalTo(aboutTableView.snp.bottom).offset(30)
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
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.firstName] ?? userProfile.firstName,
                                thingToChange: .firstName)),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.lastName] ?? userProfile.lastName,
                                thingToChange: .lastName)),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.username] ?? userProfile.username,
                                thingToChange: .username)),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.email] ?? userProfile.email,
                                thingToChange: .email)),
                height: 50),
        ])
        aboutTableDirector.updateItems(with: [
            TableCellData(
                configurator:
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.location] ?? userProfile.location,
                                thingToChange: .location)),
                height: 50),
            TableCellData(
                configurator:
                    TextFieldCellConfigurator(
                        item:
                            TextFieldData(
                                text: StoredData.inProcessUpdatedUserData[.website] ?? userProfile.portfolioURL,
                                thingToChange: .website)),
                height: 50)
        ])
    }
    private func bindViewModel(){
        viewModel.didChangeUserProfile = { [weak self] result in
            switch result {
            case .success( let profile):
                print(profile)
                DispatchQueue.main.async {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            case .failure( let error):
                print(String(describing: error))
                return
            }
        }
    }
    private func setActions(){
        profileTableDirector.actionProxy.on(action: .custom("textFieldDidChange")) { [weak self] (configurator: TextFieldCellConfigurator, cell) in
            guard let data = cell.currentData, configurator.item.text != cell.currentData?.text else {
                return
            }
            self?.thingsToChange[data.thingToChange] = data.text
            StoredData.inProcessUpdatedUserData[data.thingToChange] = data.text
        }
        aboutTableDirector.actionProxy.on(action: .custom("textFieldDidChange")) { [weak self] (configurator: TextFieldCellConfigurator, cell) in
            guard let data = cell.currentData, configurator.item.text != cell.currentData?.text else {
                return
            }
            self?.thingsToChange[data.thingToChange] = data.text
            StoredData.inProcessUpdatedUserData[data.thingToChange] = data.text
        }
    }
}

enum ThingsToChange: String {
    case username = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case email = "email"
    case location = "location"
    case website = "url"
    
    public var placeHolder: String? {
        return self.toString()
    }

    private func toString() -> String? {
        switch self {
        case .username:
            return "Username"
        case .firstName:
            return "First name"
        case .lastName:
            return "Last name"
        case .email:
            return "Email"
        case .location:
            return "Location"
        case .website:
            return "Website"
        }
    }
}
