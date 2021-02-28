import UIKit
import Combine

let myNotification = Notification.Name("com.donnywals.costomNotification")
//var subscription: AnyCancellable?
var cancellables = Set<AnyCancellable>()


func listenToNotifications() {
    NotificationCenter.default.publisher(for: myNotification)
        .sink(receiveValue: { notification in
            print("Recived a notification")
        })
        .store(in: &cancellables)
    
    NotificationCenter.default.post(Notification(name: myNotification))
}

listenToNotifications()
NotificationCenter.default.post(Notification(name: myNotification))
