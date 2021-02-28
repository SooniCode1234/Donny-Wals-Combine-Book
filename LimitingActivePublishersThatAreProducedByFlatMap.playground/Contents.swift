import UIKit
import Combine

[1, 2, 3]
    .publisher
    .print()
    .flatMap({ int in
        return Array(repeating: int, count: 2).publisher
    })
    .sink(receiveValue: { value in
        print("Got: \(value)")
    })

[1, 2, 3]
    .publisher
    .print()
    .flatMap(maxPublishers: .max(1), { int in
        return Array(repeating: int, count: 2).publisher
    })
    .sink(receiveValue: { value in
        print("Got: \(value)")
    })
