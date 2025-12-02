import SwiftUI


struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isAuthenticated {
            MainView()
        } else {
            Login()  
        }
    }
}


// ---------------------------------------------------------
// 1. MainView
// ---------------------------------------------------------
struct MainView: View {
    @StateObject var dataStore = GetData()

    var body: some View {
        TabView {
            // --- Tab 1: Home ---
            HomeView(dataStore: dataStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            // --- Tab 2: Favorites ---
            // (แก้จุดที่ 1) ส่ง dataStore ไปให้หน้านี้ด้วย
            FavoritesView(dataStore: dataStore)
                .tabItem {
                    Label("Favorite", systemImage: "heart.fill")
                }
            
            // --- Tab 3: Profile ---
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .tint(.orange)
    }
}

// ---------------------------------------------------------
// 2. HomeView
// ---------------------------------------------------------
struct HomeView: View {
    @ObservedObject var dataStore: GetData
    @State private var showAddCat = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                // --- List ---
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(dataStore.cats) { cat in
                            // (แก้จุดที่ 2) ต้องส่ง dataStore ไปด้วย เพื่อให้หน้า Detail กดหัวใจได้
                            NavigationLink(destination: CatDetailView(cat: cat, dataStore: dataStore)) {
                                CatCardView(cat: cat)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                }
                
                // --- Floating Button ---
                Button(action: {
                    showAddCat = true
                }) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding(25)
            }
            .navigationTitle("Home")
            
            .sheet(isPresented: $showAddCat) {
                AddCatView()
                    .onDisappear {
                        dataStore.loadCats()
                    }
            }
            .onAppear {
                if dataStore.cats.isEmpty {
                    dataStore.loadCats()
                }
            }
        }
    }
}




#Preview {
    ContentView()
        .environmentObject(AuthManager())  
}
