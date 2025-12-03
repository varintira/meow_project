import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthManager
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainView()
            } else {
                Login()
            }
        }
    }
}

// ⭐ ย้าย MainView ออกมาข้างนอก ContentView
struct MainView: View {
    @StateObject var dataStore = GetData()
    
    var body: some View {
        TabView {
            HomeView(dataStore: dataStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FavoritesView(dataStore: dataStore)
                .tabItem {
                    Label("Favorite", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .tint(.orange)
    }
}

// ⭐ ย้าย HomeView ออกมาข้างนอก ContentView
struct HomeView: View {
    @ObservedObject var dataStore: GetData
    @State private var showAddCat = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(dataStore.cats) { cat in
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
