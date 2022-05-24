//
//  AccountSettingsViewController.swift
//  UnsplashPremium
//
//  Created by user on 21.05.2022.
//

import UIKit
import SnapKit

class AccountSettingsViewController: UIViewController {
    
    private let viewModel = AccountSettingsViewModel()
    
    private let profile: UserProfileWrapper
    
    private let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor(named: "MediumGrayColor")
        topView.layer.cornerRadius = 15
        topView.clipsToBounds = true
        return topView
    }()
    private let photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    private let imageBottomTitle: UILabel = {
        let imageBottomTitle = UILabel()
        imageBottomTitle.textColor = .lightGray
        imageBottomTitle.text = "Change profile photo"
        imageBottomTitle.font = .systemFont(ofSize: 17, weight: .regular)
        return imageBottomTitle
    }()
    private let xButton: UIButton = {
        let xButton = UIButton()
        let image = UIImage(systemName: "xmark")
        xButton.setImage(image, for: .normal)
        xButton.backgroundColor = .clear
        xButton.tintColor = .white
        xButton.addTarget(self, action: #selector(didTapX), for: .touchUpInside)
        return xButton
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "Settings"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        return titleLabel
    }()
    private let tableView: ResizableTableView = {
        let tableView = ResizableTableView()
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        return tableView
    }()
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        return tableDirector
    }()
    
    @objc private func didTapX(){
        dismiss(animated: true, completion: nil)
    }

    init(profile: UserProfileWrapper){
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
        setUpImage(with: profile.profileImage.medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: ColorKeys.presentationBackground)
        tableView.estimatedRowHeight = 50
        layout()
        setOptions()
        setUpActions()
    }
    private func layout(){
        view.addSubview(xButton)
        xButton.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(10)
            $0.size.equalTo(40)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.centerY.equalTo(xButton)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(topView)
        topView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalToSuperview().dividedBy(5)
        }
        topView.addSubview(imageBottomTitle)
        imageBottomTitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        topView.addSubview(photoView)
        photoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalTo(imageBottomTitle.snp.top)
            $0.width.equalTo(photoView.snp.height)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(topView.snp.bottom).offset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        DispatchQueue.main.async {
            self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        }
    }
    
    private func setOptions(){
        tableDirector.updateItems(with: [
            TableCellData(configurator: AccountSettingCellConfigurator(item: "Edit Profile"), height: 50),
            TableCellData(configurator: AccountSettingCellConfigurator(item: "Change Password"), height: 50),
            TableCellData(configurator: AccountSettingCellConfigurator(item: "Account"), height: 50)
        ])
        tableView.invalidateIntrinsicContentSize()
    }
    
    private func setUpImage(with urlString: String) {
        PhotosServiceImplementation.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.photoView.image = image
            case .failure(let error):
                print("Error on downloading image: \(error)")
            }
        }
    }
    private func setUpActions(){
        tableDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: AccountSettingCellConfigurator, cell) in
            guard let strongSelf = self else { return }
            print(configurator.item)
            if configurator.item == "Edit Profile" {
                self?.navigationController?.pushViewController(EditProfileViewController(profile: strongSelf.profile, viewModel: EditProfileViewModel(service: PrivateUserServiceImplementation())), animated: true)
            }
            else if configurator.item == "Change Password" {
                self?.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            }
            else if configurator.item == "Account" {
                self?.navigationController?.pushViewController(CloseAccountViewController(), animated: true)
            }
        }
    }
}
