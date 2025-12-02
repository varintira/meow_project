import SwiftUI

struct Registration: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            Image("Roblox_Logo_2025")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            
            VStack(spacing: 24) {
                inputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                inputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                inputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                inputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // แสดง Error ถ้ามี
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 8)
            }
            
            Button {
                handleSignUp()  // แก้ตรงนี้
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
    

    private func handleSignUp() {
        // ตรวจสอบข้อมูล
        guard !email.isEmpty else {
            showError = true
            errorMessage = "Enter your Email"
            return
        }
        
        guard !fullname.isEmpty else {
            showError = true
            errorMessage = "Enter your name"
            return
        }
        
        guard password.count >= 6 else {
            showError = true
            errorMessage = "Password need atleast 6 characters"
            return
        }
        
        guard password == confirmPassword else {
            showError = true
            errorMessage = "Password not match"
            return
        }
        
        // สมัครสมาชิกสำเร็จ
        print("Sign up success: \(email)")
        
        
        // สมัครแล้ว Login เข้าเลย
        authManager.isAuthenticated = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
    }
}

#Preview {
    Registration()
        .environmentObject(AuthManager())
}
