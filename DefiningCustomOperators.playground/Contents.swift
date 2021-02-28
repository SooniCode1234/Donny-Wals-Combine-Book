import UIKit
import Combine

var baseURL = URL(string: "https://www.donnywals.com")!
var cancellables = Set<AnyCancellable>()

["/", "/the-blog", "/speaking", "/newsletter"]
    .publisher
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

extension Publisher where Output == String, Failure == Never {
    func toURLSessionDataTask(baseURL: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        if #available(iOS 14, *) {
            return self
                .flatMap({ path -> URLSession.DataTaskPublisher in
                    let url = baseURL.appendingPathComponent(path)
                    return URLSession.shared.dataTaskPublisher(for: url)
                })
                .eraseToAnyPublisher()
        } else {
            return self
                .setFailureType(to: URLError.self)
                .flatMap({ path -> URLSession.DataTaskPublisher in
                    let url = baseURL.appendingPathComponent(path)
                    return URLSession.shared.dataTaskPublisher(for: url)
                })
                .eraseToAnyPublisher()
        }
    }
}

["/", "/the-blog", "/speaking", "/newsletter"]
    .publisher
    .toURLSessionDataTask(baseURL: baseURL)
    .sink(receiveCompletion: { completion in
        print("Completed with: \(completion)")
    }, receiveValue: { result in
        print(result)
    })
    .store(in: &cancellables)





