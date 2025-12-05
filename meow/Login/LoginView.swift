import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthManager
    
    // MARK: NEW - เพิ่มตัวแปรสำหรับ Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                //image
                Image("MeowApp")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                //form fields
                VStack(spacing: 24) {
                    inputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    inputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //signin btn
                Button {
                    Task {
                        // MARK: NEW - ใช้ do-catch ดัก Error
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                        } catch {
                            // ถ้า Login พลาด ให้เด้ง Alert
                            alertMessage = "อีเมลหรือรหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง"
                            // หรือถ้าอยากแสดง Error จริงจากระบบให้ใช้: alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                //sign up btn
                NavigationLink {
                    Registration()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            // MARK: NEW - ใส่ Alert Modifier
            .alert("แจ้งเตือน", isPresented: $showAlert) {
                Button("ตกลง", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

//MARK: AuthenticationFormProtocol
extension Login: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    Login()
        .environmentObject(AuthManager())
}
