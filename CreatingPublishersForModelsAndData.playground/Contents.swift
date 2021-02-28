import UIKit
import Combine

// MARK: - PassthroughSubject

var cancellables = Set<AnyCancellable>()

let notificationSubject = PassthroughSubject<Notification, Never>()
let notificationCenter = NotificationCenter.default
let notificationName = UIResponder.keyboardWillShowNotification
let publisher = notificationCenter.publisher(for: notificationName)

publisher.sink(receiveValue: { notification in
    print(notification)
})
.store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))

notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
    notificationSubject.send(notification)
}

notificationSubject
    .sink(receiveValue: { notification in
        print(notification)
    })
    .store(in: &cancellables)

notificationCenter.post(Notification(name: notificationName))

// MARK: - CurrentValueSubject

let someLabel = UILabel()

//class Car {
//    var onBatteryChargeChange: ((Double) -> Void)?
//    var kwhInBattery = 50.0 {
//        didSet {
//            onBatteryChargeChange?(kwhInBattery)
//        }
//    }
//
//    let kwhPerKilometer = 0.14
//
//    func drive(kilometers: Double) {
//        let kwhNeeded = kilometers * kwhPerKilometer
//
//        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in battery")
//
//        kwhInBattery -= kwhNeeded
//    }
//}

class Car {
    var kwhInBattery = CurrentValueSubject<Double, Never>(50.0)
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery.value, "Can't make trip, not enough charge in battery")
        
        kwhInBattery.value -= kwhNeeded
    }
}

let car = Car()

someLabel.text = "The car now has \(car.kwhInBattery)kwh in its battery"

car.kwhInBattery
    .sink { newCharge in
        someLabel.text = "The car now has \(newCharge)kwh in its battery"
    }

car.drive(kilometers: 100)

// MARK: - CREATING PROPERTIES WITH @PUBLISHED

class Car2 {
    @Published var kwhInBattery = 50.0
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in battery")
        
        kwhInBattery -= kwhNeeded
    }
}

let car2 = Car2()

car2.$kwhInBattery
    .sink { newCharge in
        someLabel.text = "The car now has \(newCharge)kwh in its battery"
    }

