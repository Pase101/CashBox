import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var isRunning = false
    @AppStorage("orderNumber") private var orderNumber = 3483

    var body: some View {
        VStack(spacing: 30) {
            Text("CashBox")
                .font(.largeTitle)
                .bold()

            Text("Sales Notifications")
                .foregroundColor(.gray)

            Button(action: toggle) {
                Text(isRunning ? "Stop" : "Start")
                    .padding()
                    .frame(width: 200)
                    .background(isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }

    func toggle() {
        isRunning.toggle()
        if isRunning {
            scheduleAll()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    func scheduleAll() {
        // iOS allows max 64 pending notifications
        // We schedule 60 of them all at once with increasing delays
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        var currentDelay: Double = 0
        var currentOrder = orderNumber

        for _ in 0..<60 {
            let gap = Double.random(in: 20...200)
            currentDelay += gap
            currentOrder += 1

            let amount = Double.random(in: 20...150)

            let content = UNMutableNotificationContent()
            content.title = "New Order #\(currentOrder)"
            content.subtitle = "CashBox Online Store"
            content.body = String(format: "$%.2f – 1 Item", amount)
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: currentDelay, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }

        orderNumber = currentOrder
    }
}
