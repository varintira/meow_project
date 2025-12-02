import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // รูปโปรไฟล์
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("หน้าข้อมูลส่วนตัว 👤")
                    .font(.title)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // ปุ่ม Logout
                Button(action: {
                    authManager.logout()
                }) {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                        Text("Logout")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    .background(Color.red)
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("โปรไฟล์")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
