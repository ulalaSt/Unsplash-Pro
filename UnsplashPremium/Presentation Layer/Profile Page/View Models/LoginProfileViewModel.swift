//
//  LoginProfileViewModel.swift
//  UnsplashPremium
//
//  Created by user on 20.05.2022.
//

import AuthenticationServices

class LoginProfileViewModel {
    
    private let privateService: PrivateUserService
    
    init(privateService: PrivateUserService) {
        self.privateService = privateService
    }
    
    var didReceiveAuthSessionID: ((Result<String, Error>)->Void)?
    
    var didLoadUserAccessToken: ((Result<AccessToken, Error>) -> Void)?
    
    func configuredAuthSession() -> ASWebAuthenticationSession? {
        let urlString = "\(EndPoint.base)oauth/authorize?redirect_uri=\(EndPoint.redirectURI)&response_type=code&scope=\(EndPoint.authenticationScope)&\(EndPoint.clientIdParameter)"
        print(urlString)
        print("ASDASDAS")
        guard let url = URL(string: urlString) else { return nil }
        
        let callbackScheme = "authhub"
        
        let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme, completionHandler: { [weak self] (callbackURL, error) in
            guard let successURL = callbackURL, error == nil else {
                self?.didReceiveAuthSessionID?(.failure(error!))
                return
            }
            let urlStr = successURL.absoluteString
            let component = urlStr.components(separatedBy: "=")
            if component.count > 1, let authenticationId = component.last {
                self?.didReceiveAuthSessionID?(.success(authenticationId))
            }
        })
        return authSession
    }
        
    func getAccessToken(authenticationID: String) {
        privateService.getAccessToken(authenticationID: authenticationID) { [weak self] result in
            switch result {
            case .success(let accessToken):
                UserDefaults.standard.set(accessToken.access_token, forKey: DefaultKeys.currentUserAccessTokenKey)
                UserDefaults.standard.set(accessToken.scope, forKey: DefaultKeys.currentUserAccessScopeKey)
                UserDefaults.standard.setValue(accessToken.access_token, forKey: DefaultKeys.currentUserAccessTokenKey)
                self?.didLoadUserAccessToken?(.success(accessToken))
            case .failure(let error):
                self?.didLoadUserAccessToken?(.failure(error))
                return
            }
        }
    }


}
