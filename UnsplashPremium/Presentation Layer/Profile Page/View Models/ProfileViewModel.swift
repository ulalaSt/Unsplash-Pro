
import Foundation

class ProfileViewModel: UserDetailViewModel {
    
    private let privateService: PrivateUserService
    
    init(privateService: PrivateUserService, detailService: UserDetailService) {
        self.privateService = privateService
        super.init(resultsService: detailService)
    }
    
    var didLoadUserProfile: ((Result<UserProfileWrapper, Error>) -> Void)?
    
    var didLoadExtraLikedPhoto: ((Result<Photo, Error>) -> Void)?
    
    var noAccessTokenStored: (() -> Void)?

    func getUserProfile() {
        guard let accessToken = UserDefaults.standard.string(forKey: DefaultKeys.currentUserAccessTokenKey) else {
            noAccessTokenStored?()
            return
        }
        let urlString = "https://api.unsplash.com/me"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data else {
                print("rsdtfyguh")
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.failure(error!))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserProfileWrapper.self, from: data)
                print("UUUUUUUUUUU")
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.success(responseObject))
                }
            } catch {
                print("AAAAAAAAAA")
                DispatchQueue.main.async {
                    self?.didLoadUserProfile?(.failure(error))
                }
            }
        }.resume()
    }
    func getSinglePhoto(id: String){
        PhotosServiceImplementation.getSinglePhoto(with: id) { [weak self] result in
            switch result {
            case .success( let detailedPhoto):
                self?.didLoadExtraLikedPhoto?(.success(Photo(wrapper: detailedPhoto)))
            case .failure( let error):
                self?.didLoadExtraLikedPhoto?(.failure(error))
            }
        }
    }
}
