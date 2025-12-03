import SwiftUI
import FirebaseCore
import Firebase

// 1. ส่วนตั้งค่า Firebase (อันนี้เก็บไว้เหมือนเดิมเป๊ะ)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure() // ✅ เก็บอันนี้ไว้ (ให้มันรันที่นี่ที่เดียว)

    return true
  }
}

@main
struct YourApp: App {
  // เชื่อมกับ AppDelegate ด้านบน
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthManager()
    
    // ❌ ลบ init() ตรงนี้ทิ้งไปเลยครับ เพราะมันซ้ำกับข้างบน
    // init() {
    //     FirebaseApp.configure()
    // }

  var body: some Scene {
    WindowGroup {
      ContentView()
            .environmentObject(viewModel)
    }
  }
}
