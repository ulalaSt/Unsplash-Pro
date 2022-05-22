//
//  ProfileViewController.swift
//  UnsplashPremium
//
//  Created by user on 25.04.2022.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginProfileViewController: UIViewController {
        
    let viewModel: LoginProfileViewModel
    
    var authSession: ASWebAuthenticationSession?

    private let emailTextField: ProfileTextField = {
        let emailTextField = ProfileTextField()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email (not available)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        return emailTextField
    }()
    
    private let passwordTextField: ProfileTextField = {
        let passwordTextField = ProfileTextField()
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password (not available)",
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
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return loginButton
    }()
    
    private let forgotlabel: UILabel = {
        let forgotlabel = UILabel()
        forgotlabel.text = "Forgot your password?"
        forgotlabel.textColor = .white
        forgotlabel.numberOfLines = 0
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
    
    private let loginByUnsplashButton: UIButton = {
        let loginByUnsplashButton = UIButton()
        loginByUnsplashButton.backgroundColor = .lightGray
        loginByUnsplashButton.setTitle("Log In by Unsplash Authentication", for: .normal)
        loginByUnsplashButton.setTitleColor(.black, for: .normal)
        loginByUnsplashButton.layer.cornerRadius = 5
        loginByUnsplashButton.addTarget(self, action: #selector(didTapLoginByUnsplash), for: .touchUpInside)
        return loginByUnsplashButton
    }()

    @objc private func didTapLogin(){
        let alert = UIAlertController(title: "Direct login is not available", message: "Since it is the copy of Unsplash, we can not store your data. So login with Unsplash Authentication", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Login by Unsplash Authentication", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.didTapLoginByUnsplash()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapLoginByUnsplash(){
        authSession = viewModel.configuredAuthSession()
        authSession?.presentationContextProvider = self
        authSession?.start()
    }

    init(viewModel: LoginProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        layout()
        bindViewModel()
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
        view.addSubview(loginByUnsplashButton)
        loginByUnsplashButton.snp.makeConstraints{
            $0.trailing.leading.equalToSuperview().inset(10)
            $0.top.equalTo(noAccountStack.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
    }
    
    private func bindViewModel(){
        viewModel.didLoadUserAccessToken = { [weak self] userAccessToken in
            let loginViewController = ProfileViewController(viewModel: ProfileViewModel(privateService: PrivateUserServiceImplementation(), detailService: UserDetailServiceImplementation()))
            self?.addPageView(of: loginViewController)
            loginViewController.presentWelcomePage()
        }
        
        viewModel.didReceiveAuthSessionID = { [weak self] result in
            switch result {
            case .success(let authID):
                self?.viewModel.getAccessToken(authenticationID: authID)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func addPageView(of viewContoller: UIViewController){
        self.addChild(viewContoller)
        view.addSubview(viewContoller.view)
    }
}

extension LoginProfileViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}
