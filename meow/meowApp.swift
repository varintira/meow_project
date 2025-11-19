import SwiftUI
import FirebaseCore

@main
struct meowApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
