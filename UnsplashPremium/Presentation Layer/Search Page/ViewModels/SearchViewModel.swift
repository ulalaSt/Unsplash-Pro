



import Foundation

class SearchViewModel {
    
    private let searchService: SearchService
    
    var categoriesConstants = ["Nature", "Black and White", "Space", "Textures", "Abstract", "Minimal", "Animals", "Sky", "Flowers", "Travel", "Underwater", "Drones", "Architecture", "Gradients"]
    
    // initializer
    init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    // actions after request
    var didLoadCategoryPhotos: (([Category]) -> Void)?
    
    var didLoadRandomPhoto: ((Photo) -> Void)?
    
    
    // requests
    private let semaphore = DispatchSemaphore(value: 1)
    
    func getCategories() {
        var categories = [Category]()
        
        self.categoriesConstants.forEach { title in
            semaphore.wait()
            
            self.searchService.getRandomPhoto(for: title) { result in
                switch result {
                case .success(let photo):
                    categories.append(Category(title: title, photoUrl: photo.urls.small, backgroundColor: photo.color))
                    self.didLoadCategoryPhotos?(categories)
                case .failure(_):
                    print("Failed to load photos")
                }
                self.semaphore.signal()
            }
        }
        
    }
    
    func getRandomPhotos(of count: Int){
        for _ in 0..<count {
            semaphore.wait()
            
            self.searchService.getRandomPhoto { [weak self] result in
                switch result {
                case .success(let photo):
                    self?.didLoadRandomPhoto?(Photo(wrapper: photo))
                case .failure(_):
                    print("Failed to load photos")
                }
                self?.semaphore.signal()
            }
        }
    }
}
