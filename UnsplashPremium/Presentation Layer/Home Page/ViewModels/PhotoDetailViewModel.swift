



import Foundation

class PhotoDetailViewModel {
        
    private let photosService: PrivatePhotoService
    
    // initializer
    init(photosService: PrivatePhotoService) {
        self.photosService = photosService
    }
    
    // requests
    func photoLikeRequest(id: String, isLiked: Bool) {
        if isLiked {
            photosService.likePhoto(with: id)
        } else {
            photosService.dislikePhoto(with: id)
        }
        
    }
}
