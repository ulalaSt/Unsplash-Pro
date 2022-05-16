//
//  ProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    private let emailTextField: ProfileTextField = {
        let emailTextField = ProfileTextField()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        return emailTextField
    }()
    
    private let passwordTextField: ProfileTextField = {
        let passwordTextField = ProfileTextField()
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        return passwordTextField
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.backgroundColor = .white
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 5
        return loginButton
    }()
    
    private let forgotlabel: UILabel = {
        let forgotlabel = UILabel()
        forgotlabel.text = "Forgot your password?"
        forgotlabel.textColor = .white
        forgotlabel.font = .systemFont(ofSize: 15)
        return forgotlabel
    }()
    
    private let noAccountLabel: UILabel = {
        let noAccountLabel = UILabel()
        noAccountLabel.text = "Don't have an account?"
        noAccountLabel.textColor = .white
        noAccountLabel.font = .systemFont(ofSize: 20)
        return noAccountLabel
    }()
    
    private let joinLabel: UILabel = {
        let joinLabel = UILabel()
        joinLabel.text = "Join"
        joinLabel.textColor = .white
        joinLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        return joinLabel
    }()

    private lazy var noAccountStack: UIStackView = {
        let noAccountStack = UIStackView()
        noAccountStack.axis = .horizontal
        noAccountStack.alignment = .center
        noAccountStack.addArrangedSubview(noAccountLabel)
        noAccountStack.addArrangedSubview(joinLabel)
        return noAccountStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        layout()
        // Do any additional setup after loading the view.
    }
    private func layout(){
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(60)
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.height.equalTo(emailTextField)
        }
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(forgotlabel)
        forgotlabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        view.addSubview(noAccountStack)
        noAccountStack.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(forgotlabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
    }
}
