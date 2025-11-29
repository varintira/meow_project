import SwiftUI

// ---------------------------------------------------------
// 1. MainView (ตัวแม่สุด: มีหน้าที่สร้าง Tab Bar ข้างล่าง)
// ---------------------------------------------------------
struct MainView: View {
    // สร้าง DataStore ก้อนเดียวที่นี่ เพื่อส่งให้ทุกหน้าใช้ร่วมกัน
    @StateObject var dataStore = GetData()

    var body: some View {
        TabView {
            // --- Tab 1: หน้าแรก (รายการแมว) ---
            HomeView(dataStore: dataStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            // --- Tab 2: หน้าถูกใจ (Favorites) ---
            FavoritesView()
                .tabItem {
                    Label("Favorite", systemImage: "heart.fill")
                }
            
            // --- Tab 3: โปรไฟล์ (Profile) ---
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .tint(.orange) // (Optional) เปลี่ยนสีไอคอนที่เลือกเป็นสีส้ม
    }
}

// ---------------------------------------------------------
// 2. HomeView (หน้ารายการแมวเดิมของคุณ)
// ---------------------------------------------------------
struct HomeView: View {
    @ObservedObject var dataStore: GetData // รับข้อมูลมาจากตัวแม่

    var body: some View {
        NavigationStack { // Nav Bar บน (Top Bar) อยู่ใน Tab นี้
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(dataStore.cats) { cat in
                        NavigationLink(destination: CatDetailView(cat: cat)) {
                            CatCardView(cat: cat) //
                                .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 80) // เว้นระยะล่างเผื่อติด Tab Bar
            }
            .navigationTitle("Home")
            .onAppear {
                // โหลดข้อมูลถ้ายังไม่มี
                if dataStore.cats.isEmpty {
                    dataStore.loadCats()
                }
            }
        }
    }
}

// ---------------------------------------------------------
// 3. หน้าอื่นๆ (สร้างไว้ทดสอบ Tab Bar)
// ---------------------------------------------------------
struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("รายการที่กด Love ไว้ ❤️")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .navigationTitle("ถูกใจ")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("หน้าข้อมูลส่วนตัว 👤")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .navigationTitle("โปรไฟล์")
        }
    }
}


// Preview ดูผลลัพธ์
#Preview {
    MainView()
}
