import UIKit
import Combine

let result = ["one", "2", "three", "4", "5"]
    .compactMap({ Int($0) })
print(result)

["one", "2", "three", "4", "5"]
    .publisher
    .compactMap({ Int($0) })
    .sink(receiveValue: { int in
        print(int)
    })

["one", "2", "three", "4", "5"]
    .publisher
    .map({ Int($0) })
    .replaceNil(with: 0)
    .sink(receiveValue: { int in
        print(int)
    })

["one", "2", "three", "4", "5"]
    .publisher
    .map({ Int($0) })
    .replaceNil(with: 0)
    .compactMap({ $0 })
    .sink(receiveValue: { int in
        print(int)
    })

let numbers = [1, 2, 3, 4]

let mapped = numbers.map {
    Array(repeating: $0, count: $0)
}

let flatMapped = numbers.flatMap {
    Array(repeating: $0, count: $0)
}

var baseURL = URL(string: "https://www.donnywals.com")!

["/", "/the-blog", "/speaking", "/newsletter"].publisher
  .map({ path in
    let url = baseURL.appendingPathComponent(path)
    return URLSession.shared.dataTaskPublisher(for: url)
  })
  .sink(receiveCompletion: { completion in
    print("Completed with: \(completion)")
  }, receiveValue: { result in
    print(result)
  })

var cancellables = Set<AnyCancellable>()

["/", "/the-blog", "/speaking", "/newsletter"].publisher
    .setFailureType(to: URLError.self)
    .flatMap({ path -> URLSession.DataTaskPublisher in
    let url = baseURL.appendingPathComponent(path)
    return URLSession.shared.dataTaskPublisher(for: url)
  })
  .sink(receiveCompletion: { completion in
    print("Completed with: \(completion)")
  }, receiveValue: { result in
    print(result)
  })
    .store(in: &cancellables)
