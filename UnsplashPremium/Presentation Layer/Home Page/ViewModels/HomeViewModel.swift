



import Foundation

class HomeViewModel {
    private let photosService: PhotosService
    
    // initializer
    init(photosService: PhotosService) {
        self.photosService = photosService
    }
    
    
    // actions after request
    var didLoadTopics: (([TopicWrapper]) -> Void)?

    var didLoadEditorialPhotos: (([PhotoWrapper]) -> Void)?
    
    var didLoadPhotosForTopic: (([PhotoWrapper]) -> Void)?
    
    
    // requests
    func getEditorialPhotos() {
        photosService.getEditorialPhotos {[weak self] result in
            switch result {
            case .success(let photos):
                self?.didLoadEditorialPhotos?(photos)
            case .failure(_):
                print("Failed to load photos")
            }
        }
    }
    
    func getAllTopics() {
        photosService.getAllTopics {[weak self] result in
            switch result {
            case .success(let topics):
                self?.didLoadTopics?(topics)
            case .failure(let error):
                print("Failed to load topics with error: \(error.localizedDescription)")
            }
        }
    }
    
    func getPhotosFor(topic: Topic){
        photosService.getPhotosForTopic(topicID: topic.id) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.didLoadPhotosForTopic?(photos)
            case .failure(_):
                print("Failed to load photos")
            }
        }
    }
}
