import SwiftUI
import FirebaseAuth // (1) อย่าลืม import นี้

struct FavoritesView: View {
    @ObservedObject var dataStore: GetData
    
    // (2) เรียก AuthManager เพื่อเอา User ID
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack {
            Group {
                if dataStore.favoriteCatsList.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("ยังไม่มีรายการโปรด")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(dataStore.favoriteCatsList) { cat in
                                NavigationLink(destination: CatDetailView(cat: cat, dataStore: dataStore)) {
                                    CatCardView(cat: cat)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("รายการโปรด ❤️")
            .onAppear {
                // (3) ดึง UID ของคนที่ล็อกอินอยู่ แล้วสั่งโหลด
                if let userID = authManager.userSession?.uid {
                    dataStore.loadFavorites(userID: userID)
                }
            }
        }
    }
}
