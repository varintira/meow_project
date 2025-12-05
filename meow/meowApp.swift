import SwiftUI
import FirebaseCore
import Firebase

// 1. ส่วนตั้งค่า Firebase (อันนี้เก็บไว้เหมือนเดิมเป๊ะ)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthManager()
    
  
  var body: some Scene {
    WindowGroup {
      ContentView()
            .environmentObject(viewModel)
    }
  }
}
