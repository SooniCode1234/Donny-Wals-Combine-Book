import UIKit
import Combine

class Car {
    @Published var kwhInBattery = 50.0
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in batter")
        
        kwhInBattery -= kwhNeeded
    }
}

let car = Car()
let someLabel = UILabel()

car.$kwhInBattery
    .sink(receiveValue: { newCharge in
        someLabel.text = "The car now has \(newCharge) in its battery"
    })

struct CarViewModel {
    var car: Car
    
    mutating func drive(kilometers: Double) {
        let kwhNeeded = kilometers * car.kwhPerKilometer
        
        assert(kwhNeeded <= car.kwhInBattery, "Can't make trip, not enough charge in batter")
        
        car.kwhInBattery -= kwhNeeded
    }
    
    lazy var batterySubject: AnyPublisher<String?, Never> = {
        return car.$kwhInBattery
            .map({ newCharge in
                return "The car now has \(newCharge) in its battery"
            })
            .eraseToAnyPublisher()
    }()
}

class CarStatusViewController {
    let label = UILabel()
    let button = UIButton()
    var viewModel: CarViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CarViewModel) {
        self.viewModel = viewModel
    }
    
    // setup code goes here
    
    func setupLabel() {
        viewModel.batterySubject
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }
    
    func buttonTapped() {
        viewModel.drive(kilometers: 10)
    }
}
