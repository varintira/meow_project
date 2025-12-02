import SwiftUI
import FirebaseCore

// 1. ส่วนตั้งค่า Firebase (อันนี้เก็บไว้เหมือนเดิมเป๊ะ)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure() // สั่งเปิด Firebase

    return true
  }
}

@main
struct YourApp: App {
  // เชื่อมกับ AppDelegate ด้านบน
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      // ------------------------------------------------------------
      // จุดที่ต้องแก้จากโค้ดตัวอย่าง Firebase:
      // 1. ลบ NavigationView ออก (เพราะ MainView เราจัดการเรื่อง Nav เองแล้ว)
      // 2. ใส่ MainView() ลงไปตรงๆ เลย
      // ------------------------------------------------------------
      MainView()
    }
  }
}
