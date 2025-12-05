import SwiftUI

struct FavoritesView: View {
    @ObservedObject var dataStore: GetData
    
    // ✅ เพิ่มบรรทัดนี้: ดึงค่า userID จากที่บันทึกไว้ในเครื่อง
    @AppStorage("current_user_id") var currentUser: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if dataStore.favoriteCatsList.isEmpty {
                    // ... (โค้ดส่วนเดิม) ...
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("ยังไม่มีรายการโปรด")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                } else {
                    // ... (โค้ดส่วนเดิม) ...
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
                // ✅ ตรวจสอบว่ามี user หรือไม่ก่อนโหลด
                if !currentUser.isEmpty {
                    dataStore.loadFavorites(userID: currentUser)
                }
            }
        }
    }
}
