import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthManager
    
    var body: some View {
        NavigationStack {
            Group {
                if let user = viewModel.currentUser {
                    List {
                        Section {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section("General") {
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
                        
                        Section("Account") {
                            Button {
                                viewModel.signOut()
                            } label: {
                                SettingView(imageName: "arrow.left.circle.fill",
                                            title: "Sign out",
                                            tintColor: .red)
                            }
                            
                            
                            
                        }
                    }
                    .navigationTitle("Profile")  
                }
            }
        }
    }
    
}
