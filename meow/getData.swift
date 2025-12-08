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
    let img: String // เป็น String เพื่อรองรับ Base64 และ URL
    let latitude: Double?
    let longitude: Double?
    let phone: String
}

struct Fav: Identifiable {
    let id: String
    let catID: String
    let userID: String // ระบุเจ้าของ Fav
}


// MARK: - getData Class
class GetData: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var cats: [Cat] = []
    @Published var favorites: [Fav] = []
    @Published var users: [User] = [] // จะทำงานได้ต้องมีไฟล์ User.swift

    // กรองแมวที่ User คนปัจจุบันกด Fav
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
                    let imgString = data["img"] as? String ?? ""
                    
                    return Cat(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        locationFound: data["locationFound"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        temperament: data["temperament"] as? String ?? "",
                        createdBy: data["createdBy"] as? String ?? "",
                        img: imgString,
                        latitude: data["latitude"] as? Double,
                        longitude: data["longitude"] as? Double,
                        phone: data["phone"] as? String ?? ""
                    )
                } ?? []
            }
        }
    }

    // MARK: - Load Favorites (ต้องใส่ UserID)
    func loadFavorites(userID: String) {
        db.collection("favorites")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                
            if let error = error {
                print("❌ Load Favorites error:", error)
                return
            }
            
            DispatchQueue.main.async {
                self.favorites = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return Fav(
                        id: doc.documentID,
                        catID: data["catID"] as? String ?? "",
                        userID: data["userID"] as? String ?? ""
                    )
                } ?? []
            }
        }
    }
    
    // MARK: - Favorite Logic
    func isFavorite(_ cat: Cat) -> Bool {
        return favorites.contains(where: { $0.catID == cat.id })
    }

    func toggleFavorite(_ cat: Cat, userID: String) {
        if let existingFav = favorites.first(where: { $0.catID == cat.id }) {
            // ลบออก
            db.collection("favorites").document(existingFav.id).delete() { err in
                if let err = err { print("Error removing fav: \(err)") }
            }
            if let index = favorites.firstIndex(where: { $0.id == existingFav.id }) {
                favorites.remove(at: index)
            }
        } else {
            // เพิ่มใหม่
            let newRef = db.collection("favorites").document()
            let data: [String: Any] = [
                "catID": cat.id,
                "userID": userID
            ]
            newRef.setData(data) { err in
                if let err = err { print("Error adding fav: \(err)") }
            }
            let newFav = Fav(id: newRef.documentID, catID: cat.id, userID: userID)
            favorites.append(newFav)
        }
    }
    
    // MARK: - Admin Functions
    func deleteCat(_ cat: Cat) {
        db.collection("cats").document(cat.id).delete() { err in
            if let err = err {
                print("Error removing cat: \(err)")
            } else {
                print("Cat successfully deleted!")
                DispatchQueue.main.async {
                    if let index = self.cats.firstIndex(where: { $0.id == cat.id }) {
                        self.cats.remove(at: index)
                    }
                }
            }
        }
    }

}
