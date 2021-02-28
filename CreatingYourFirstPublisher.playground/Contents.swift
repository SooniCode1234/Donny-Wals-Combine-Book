import Combine
import UIKit

let publisher = [1, 2, 3].publisher

let myUrl = URL(string: "https://www.donnywals.com")!

let publisher2 = URLSession.shared.dataTaskPublisher(for: myUrl)

let puublisher3 = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
