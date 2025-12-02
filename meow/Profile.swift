import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text(User.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72,height: 72)
                        .background(Color(.systemGray))
                        .clipShape(Circle())
                    
                    VStack (alignment: .leading, spacing: 4) {
                        Text(User.MOCK_USER.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top , 4)
                        
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                }
            }
            
            Section ("General") {
                HStack {
                    SettingView(imageName: "gear",
                                title: "Version",
                                tintColor: Color(.systemGray))
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Section ("Account") {
                Button {
                    print("Sign out..")
                } label: {
                    SettingView(imageName: "arrow.left.circle.fill",
                                title: "Sign out",
                                tintColor: .red)
                }
                
                Button {
                    print("Delecte account...")
                } label: {
                    SettingView(imageName: "xmark.circle.fill",
                                title: "Delete Account",
                                tintColor: .red)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
