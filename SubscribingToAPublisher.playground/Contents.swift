import UIKit
import Combine

[1, 2, 3]
    .publisher
    .sink(receiveCompletion: { completion in
        print("Publisher completed: \(completion)")
    }, receiveValue: { value in
        print("Recived a value: \(value)")
    })


[1, 2, 3]
    .publisher
    .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Finished successfully")
            case .failure(let error):
                print(error)
            }
    }, receiveValue: { value in
        print("Recived a value: \(value)")
    })

[1, 2, 3]
    .publisher
    .sink(receiveValue: { value in
        print("Recived a value: \(value)")
    })


class User {
    var email: String = "default"
}

var user = User()
["test@email.com"]
    .publisher
    .assign(to: \.email, on: user)
 
