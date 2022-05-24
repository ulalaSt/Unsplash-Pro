//
//  WelcomeViewController.swift
//  UnsplashPremium
//
//  Created by user on 20.05.2022.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.textColor = .white
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = .systemFont(ofSize: 25, weight: .bold)
        return welcomeLabel
    }()
    
    private let guaranteeLabel: UILabel = {
        let guaranteeLabel = UILabel()
        guaranteeLabel.text = "Before uploading, Ulan guaratees that your information is not listened and not used for any personal uses. Just have a fun with app!"
        guaranteeLabel.numberOfLines = 0
        guaranteeLabel.textColor = .white
        guaranteeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return guaranteeLabel
    }()
    
    private let appDescriptionLabel: UILabel = {
        let appDescriptionLabel = UILabel()
        appDescriptionLabel.text = "•  Almost exact copy of Unsplash App \n•  Detailed approach\n•  Detailed search\n•  Authorization and actions that need it are available\n•  Structured Code and more..."
        appDescriptionLabel.numberOfLines = 0
        appDescriptionLabel.textColor = .white
        appDescriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return appDescriptionLabel
    }()
    private let licenseTextView: UITextView = {
        let licenseTextView = UITextView()
        licenseTextView.backgroundColor = .darkGray
        licenseTextView.sizeToFit()
        licenseTextView.text = "Every photo in Unsplash is shared under the Unsplash License which allows people to use photos from Unsplash for free, including for commercial purposes."
        licenseTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        licenseTextView.textColor = .white
        licenseTextView.font = .systemFont(ofSize: 14, weight: .regular)
        return licenseTextView
    }()
    private let agreeButton: UIButton = {
        let agreeButton = UIButton()
        agreeButton.backgroundColor = .white
        agreeButton.setTitle("I agree", for: .normal)
        agreeButton.setTitleColor(.black, for: .normal)
        agreeButton.layer.cornerRadius = 5
        agreeButton.clipsToBounds = true
        return agreeButton
    }()
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        return cancelButton
    }()

    init(name: String){
        super.init(nibName: nil, bundle: nil)
        welcomeLabel.text = "Hello, \(name) 👋. \nWelcome to My App!"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: ColorKeys.presentationBackground)
        layout()
    }
    private func layout() {
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(20)
        }
        view.addSubview(guaranteeLabel)
        guaranteeLabel.snp.makeConstraints{
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        view.addSubview(appDescriptionLabel)
        appDescriptionLabel.snp.makeConstraints{
            $0.top.equalTo(guaranteeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        view.addSubview(agreeButton)
        agreeButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(50)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(40)
            $0.width.equalTo(60)
        }
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{
            $0.trailing.equalTo(agreeButton.snp.leading).offset(-5)
            $0.bottom.size.equalTo(agreeButton)
        }
        view.addSubview(licenseTextView)
        licenseTextView.snp.makeConstraints{
            $0.top.equalTo(appDescriptionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(agreeButton.snp.top).offset(-20)
        }
    }

}
