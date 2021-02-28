import UIKit
import Combine

struct CardModel: Hashable, Decodable {
    let title: String
    let subTitle: String
    let imageName: String
}

class DataProvider {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    
    func fetch() {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
        }
        
        dataSubject.value = cards
    }
}

class DataProvider2 {
    func fetch() -> AnyPublisher<[CardModel], Never> {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
        }
        
        return Just(cards)
            .eraseToAnyPublisher()
    }
}

class DataProvider3 {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    
    var currentPage = 0
    var cancellables = Set<AnyCancellable>()
    
    func fetchNextPage() {
        let url = URL(string: "https://myserver.com/page/\(currentPage)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .sink(receiveCompletion: { _ in
                // handle completion
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                let jsonDecoder = JSONDecoder()
                if let models = try? jsonDecoder.decode([CardModel].self, from: value.data) {
                    self.dataSubject.value += models
                }
            }).store(in: &cancellables)
    }
}

class DataProvider4 {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    
    var currentPage = 0
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage(named imageName: String) -> AnyPublisher<UIImage?, URLError> {
        let url = URL(string: "https://imageserver.com/\(imageName)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { result in
                return UIImage(data: result.data)
            }
            .eraseToAnyPublisher()
    }
}

class CardCell: UICollectionViewCell {
    var cancellable: Cancellable?
    let imageView = UIImageView()
    
    
//  q  let datasource = UICollectionViewDiffableDataSource<Int, CardModel>.init(collectionView: collectionView) { collectionView, indexPath, item in
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as! CardCell
//
//      cell.cancellable = self.dataProvider.fetchImage(named: item.imageName)
//        .sink(receiveCompletion: { completion in
//          // handle errors if needed
//        }, receiveValue: { image in
//          DispatchQueue.main.async {
//            cell.imageView.image = image
//          }
//        })
//
//      return cell
//    }
}

