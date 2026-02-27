import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var isRunning = false
    @State private var orderNumber = 3483

    var body: some View {
        VStack(spacing: 30) {
            Text("CashBox")
                .font(.largeTitle)
                .bold()

            Text("Sales Simulator")
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
            scheduleNext()
        }
    }

    func scheduleNext() {
        guard isRunning else { return }

        let delay = Double.random(in: 20...120)
        let amount = Double.random(in: 20...150)
        orderNumber += 1

        let content = UNMutableNotificationContent()
        content.title = "New Order #\(orderNumber)"
        content.subtitle = "CashBox Online Store (Simulation)"
        content.body = String(format: "$%.2f – 1 Item", amount)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            scheduleNext()
        }
    }
}