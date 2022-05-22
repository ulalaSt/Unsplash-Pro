//
//  EditProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 22.05.2022.
//

import UIKit
import SnapKit

class CloseAccountViewController: UIViewController {

    private let warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.text = "WARNING"
        warningLabel.textColor = .lightGray
        warningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        return warningLabel
    }()
    
    private let warningTextLabel: UILabel = {
        let warningTextLabel = UILabel()
        warningTextLabel.text = "Closing your account is not possible in this app. API does not allow to do so since it is extremely private action. In any case, you can do it on Unsplash Browser. Please skip this part and just enjoy by other parts of this app. I appologize for inconvenience!"
        warningTextLabel.numberOfLines = 0
        warningTextLabel.textColor = .white
        warningTextLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return warningTextLabel
    }()
    
    private let passWordView: UIView = {
        let passWordView = UIView()
        passWordView.backgroundColor = .gray
        passWordView.layer.cornerRadius = 10
        passWordView.clipsToBounds = true
        return passWordView
    }()
    
    private let passWordTextField: UITextField = {
        let passWordTextField = UITextField()
        passWordTextField.textColor = .white
        passWordTextField.font = .systemFont(ofSize: 20, weight: .semibold)
        passWordTextField.backgroundColor = .clear
        let attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
            ])
        passWordTextField.attributedPlaceholder = attributedPlaceholder
        return passWordTextField
    }()
    
    private let linkLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.text = "unsplash.com"
        linkLabel.textColor = .white
        linkLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        linkLabel.sizeToFit()
        return linkLabel
    }()
    
    private let closeAccountButton: UIButton = {
        let closeAccountButton = UIButton()
        closeAccountButton.layer.cornerRadius = 10
        closeAccountButton.clipsToBounds = true
        closeAccountButton.setTitle("Close Account", for: .normal)
        closeAccountButton.setTitleColor(UIColor.systemRed, for: .normal)
        closeAccountButton.backgroundColor = .gray
        return closeAccountButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Close Account"
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem = cancelButton
        view.backgroundColor = .darkGray
        layout()
        bindViewModel()
        setActions()
    }
    
    @objc private func didTapCancel(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func layout(){
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(warningTextLabel)
        warningTextLabel.snp.makeConstraints{
            $0.top.equalTo(warningLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        view.addSubview(passWordView)
        passWordView.snp.makeConstraints{
            $0.top.equalTo(warningTextLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
        passWordView.addSubview(passWordTextField)
        passWordTextField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        view.addSubview(closeAccountButton)
        closeAccountButton.snp.makeConstraints{
            $0.top.equalTo(passWordView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel(){
        
    }
    private func setActions(){
        
    }
}
