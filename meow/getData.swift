import Foundation
import FirebaseFirestore
import SwiftUI

// MARK: - Models (เหมือนเดิม)
struct Cat: Identifiable {
    let id: String
    let name: String
    let gender: String
    let locationFound: String
    let description: String
    let temperament: String
    let createdBy: String
    let img: URL
}

struct Fav: Identifiable {
    let id: String
    let catID: String
    // ปกติต้องมี userID ด้วย แต่เอาตามที่คุณมีก่อนนะครับ
}

struct Review: Identifiable {
    let id: String
    let comment: String
    let catID: String
    let rating: String
    let userID: String
}

struct User: Identifiable {
    let id: String
    let email: String
    let password: String
}

// MARK: - getData Class
class GetData: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var cats: [Cat] = []
    @Published var favorites: [Fav] = [] // เก็บรายการ ID ของแมวที่ชอบ
    @Published var reviews: [Review] = []
    @Published var users: [User] = []

    // ------------------------------------------------------------------
    // (ใหม่) 1. ตัวแปรนี้จะ "กรอง" เอาเฉพาะแมวที่มี ID ตรงกับใน Favorites มาให้
    // เอาไว้ใช้แสดงผลในหน้า FavoritesView
    // ------------------------------------------------------------------
    var favoriteCatsList: [Cat] {
        return cats.filter { cat in
            favorites.contains(where: { $0.catID == cat.id })
        }
    }

    // MARK: - Load Cats (เหมือนเดิม)
    func loadCats() {
        db.collection("cats").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Cats error:", error)
                return
            }
            self.cats = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return Cat(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    locationFound: data["locationFound"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    temperament: data["temperament"] as? String ?? "",
                    createdBy: data["createdBy"] as? String ?? "",
                    img: URL(string: data["img"] as? String ?? "")!
                )
            } ?? []
        }
    }

    // MARK: - Load Favorites (เหมือนเดิม)
    func loadFavorites() {
        db.collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Favorites error:", error)
                return
            }
            self.favorites = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return Fav(
                    id: doc.documentID,
                    catID: data["catID"] as? String ?? ""
                )
            } ?? []
        }
    }
    
    // ------------------------------------------------------------------
    // (ใหม่) 2. ฟังก์ชันเช็คว่าแมวตัวนี้กด Fav หรือยัง?
    // ------------------------------------------------------------------
    func isFavorite(_ cat: Cat) -> Bool {
        return favorites.contains(where: { $0.catID == cat.id })
    }

    // ------------------------------------------------------------------
    // (ใหม่) 3. ฟังก์ชันกดหัวใจ (ถ้ามีให้ลบ ถ้าไม่มีให้เพิ่ม)
    // ------------------------------------------------------------------
    func toggleFavorite(_ cat: Cat) {
        // เช็คก่อนว่ามีไหม
        if let existingFav = favorites.first(where: { $0.catID == cat.id }) {
            // --- กรณีมีอยู่แล้ว ให้ลบออก ---
            
            // 1. ลบจาก Firebase
            db.collection("favorites").document(existingFav.id).delete() { err in
                if let err = err { print("Error removing fav: \(err)") }
            }
            
            // 2. ลบจากตัวแปรในแอป (เพื่อให้หน้าจอเปลี่ยนทันทีไม่ต้องรอโหลดใหม่)
            if let index = favorites.firstIndex(where: { $0.id == existingFav.id }) {
                favorites.remove(at: index)
            }
            
        } else {
            // --- กรณีไม่มี ให้เพิ่มใหม่ ---
            
            // 1. เพิ่มลง Firebase
            let newRef = db.collection("favorites").document() // สร้าง ID ใหม่
            let data: [String: Any] = ["catID": cat.id]
            
            newRef.setData(data) { err in
                if let err = err { print("Error adding fav: \(err)") }
            }
            
            // 2. เพิ่มลงตัวแปรในแอป
            let newFav = Fav(id: newRef.documentID, catID: cat.id)
            favorites.append(newFav)
        }
    }

    // MARK: - Load Reviews & Users (เหมือนเดิม)
    func loadReviews() {
        // ... (โค้ดเดิมของคุณ) ...
    }

    func loadUsers() {
        // ... (โค้ดเดิมของคุณ) ...
    }

    // MARK: - Load All Data
    func loadAllData() {
        loadCats()
        loadFavorites()
        // loadReviews()
        // loadUsers()
    }
}
