import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login(email: String, password: String) -> Bool {
        // ตรวจสอบ Login (ตัวอย่าง)
        if !email.isEmpty && !password.isEmpty {
            isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            return true
        }
        return false
    }
    
    func logout() {
        isAuthenticated = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
