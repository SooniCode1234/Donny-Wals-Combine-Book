import UIKit
import Combine

let myLabel = UILabel()

[1, 2, 3]
    .publisher
    .sink(receiveValue: { int in
        myLabel.text = "Current value: \(int)"
    })

[1, 2, 3]
    .publisher
    .map({ int in
        return "Current value: \(int)"
    })
    .sink(receiveValue: { string in
        myLabel.text = string
    })

let someURL = URL(string: "https://www.donnywals.com")!

// URLSession.DataTaskPublisher
let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: someURL)

let mappedPublisher = dataTaskPublisher
    .map({ response in
        return response.data
    })
    
struct User: Decodable {
    let name: String
}

let userNameLabel = UILabel()

let dataTaskPublisher2 = URLSession.shared.dataTaskPublisher(for: someURL)
    .retry(1)
    .map({$0.data})
    .decode(type: User.self, decoder: JSONDecoder())
    .map { $0.name }
    .replaceError(with: "Unknown")
    .assign(to: \.text, on: userNameLabel)
