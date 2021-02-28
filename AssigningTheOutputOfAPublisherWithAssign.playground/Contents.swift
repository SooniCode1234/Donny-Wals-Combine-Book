import UIKit
import Combine

struct CardModel: Decodable {
}

class DataProvider {
    @Published var fetchedModels = [CardModel]()
    
    var currentPage = 0
    var cancellables = Set<AnyCancellable>()
    
    func fetchNextPage() {
        let url = URL(string: "https://myserver.com/page/\(currentPage)")!
        currentPage += 1
        
        URLSession.shared.dataTaskPublisher(for: url)
              .tryMap({ [weak self] value -> [CardModel] in
                let jsonDecoder = JSONDecoder()
                let models = try jsonDecoder.decode([CardModel].self, from: value.data)
                let currentModels = self?.fetchedModels ?? []

                return currentModels + models
              })
              .replaceError(with: fetchedModels)
              .assign(to: &$fetchedModels)
    }
}


