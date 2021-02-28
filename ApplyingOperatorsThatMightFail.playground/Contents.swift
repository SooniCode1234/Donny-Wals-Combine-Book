import UIKit
import Combine

enum MyError: Error {
    case outOfBounds
}

[1, 2, 3]
    .publisher
    .tryMap({ int -> Int in
        guard int < 3 else {
            throw MyError.outOfBounds
        }
        
        return int * 2
    })
    .sink(receiveCompletion: { completion in
        print(completion)
    }) { val in
        print(val)
    }

