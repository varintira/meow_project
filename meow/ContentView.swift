import SwiftUI
import FirebaseFirestore


struct ContentView: View {
    @StateObject var dataStore = GetData()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(dataStore.cats) { cat in
                    CatCardView(cat: cat)
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
                }
            }
        }
        .onAppear {
            dataStore.loadCats()
        }
    }
}

#Preview {
    ContentView()
}
