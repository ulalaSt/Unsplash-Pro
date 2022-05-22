
import Foundation

class ProfileViewModel: UserDetailViewModel {
    
    private let privateService: PrivateUserService
    
    init(privateService: PrivateUserService, detailService: UserDetailService) {
        self.privateService = privateService
        super.init(resultsService: detailService)
    }
    
    var didLoadUserProfile: ((Result<UserProfileWrapper, Error>) -> Void)?
    
    var noAccessTokenStored: (() -> Void)?
    

    func getUserProfile() {
        guard let accessToken = EndPoint.currentUserAccessToken else {
            noAccessTokenStored?()
            return
        }
        let urlString = "https://api.unsplash.com/me"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.failure(error!))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserProfileWrapper.self, from: data)
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.success(responseObject))
                }
            } catch {
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.failure(error))
                }
            }
        }.resume()
    }
}
