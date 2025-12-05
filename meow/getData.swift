import Foundation
import FirebaseFirestore
import SwiftUI

// MARK: - Models
struct Cat: Identifiable {
    let id: String
    let name: String
    let gender: String
    let locationFound: String
    let description: String
    let temperament: String
    let createdBy: String
    
   
    let img: String
}

struct Fav: Identifiable {
    let id: String
    let catID: String
}

struct Review: Identifiable {
    let id: String
    let comment: String
    let catID: String
    let rating: String
    let userID: String
}


// MARK: - getData Class
class GetData: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var cats: [Cat] = []
    @Published var favorites: [Fav] = []
    @Published var reviews: [Review] = []
//    @Published var users: [User] = []

    var favoriteCatsList: [Cat] {
        return cats.filter { cat in
            favorites.contains(where: { $0.catID == cat.id })
        }
    }

    // MARK: - Load Cats
    func loadCats() {
        db.collection("cats").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Cats error:", error)
                return
            }
            
            DispatchQueue.main.async {
                self.cats = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    
                    // (แก้ไข 2) รับข้อมูลมาเป็น String ตรงๆ (ไม่ต้องแปลงเป็น URL)
                    let imgString = data["img"] as? String ?? ""
                    
                    return Cat(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        locationFound: data["locationFound"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        temperament: data["temperament"] as? String ?? "",
                        createdBy: data["createdBy"] as? String ?? "",
                        img: imgString // ส่ง String ไปเลย
                    )
                } ?? []
            }
        }
    }

    // MARK: - Load Favorites (เหมือนเดิม)
    func loadFavorites() {
        db.collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Favorites error:", error)
                return
            }
            
            DispatchQueue.main.async {
                self.favorites = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return Fav(
                        id: doc.documentID,
                        catID: data["catID"] as? String ?? ""
                    )
                } ?? []
            }
        }
    }
    
    // MARK: - Favorite Logic (เหมือนเดิม)
    func isFavorite(_ cat: Cat) -> Bool {
        return favorites.contains(where: { $0.catID == cat.id })
    }

    func toggleFavorite(_ cat: Cat) {
        if let existingFav = favorites.first(where: { $0.catID == cat.id }) {
            db.collection("favorites").document(existingFav.id).delete() { err in
                if let err = err { print("Error removing fav: \(err)") }
            }
            if let index = favorites.firstIndex(where: { $0.id == existingFav.id }) {
                favorites.remove(at: index)
            }
        } else {
            let newRef = db.collection("favorites").document()
            let data: [String: Any] = ["catID": cat.id]
            newRef.setData(data) { err in
                if let err = err { print("Error adding fav: \(err)") }
            }
            let newFav = Fav(id: newRef.documentID, catID: cat.id)
            favorites.append(newFav)
        }
    }

    // MARK: - Load Reviews & Users
    func loadReviews() {
        // ... (เหมือนเดิม) ...
    }

    func loadUsers() {
        // ... (เหมือนเดิม) ...
    }

    // MARK: - Load All Data
    func loadAllData() {
        loadCats()
        loadFavorites()
    }
}
