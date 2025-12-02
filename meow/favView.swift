import SwiftUI


struct FavoritesView: View {
    @ObservedObject var dataStore: GetData

    var body: some View {
        NavigationStack {
            Group {
                // เรียกใช้ favoriteCatsList (ตัวแปรใหม่ใน GetData)
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
                            // วนลูปเฉพาะแมวที่ Fav
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
                // โหลดข้อมูลล่าสุดเสมอ
                dataStore.loadFavorites()
            }
        }
    }
}
