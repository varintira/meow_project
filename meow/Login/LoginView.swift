import SwiftUI

struct Login: View {
    @EnvironmentObject var authManager: AuthManager  // เพิ่มบรรทัดนี้
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                //image
                Image("Roblox_Logo_2025")
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
                    // แก้ตรงนี้
                    let success = authManager.login(email: email, password: password)
                    if success {
                        print("Login success!")
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
        }
    }
}

#Preview {
    Login()
        .environmentObject(AuthManager())
}
