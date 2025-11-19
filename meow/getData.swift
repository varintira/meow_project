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
    let img:URL
}

//struct Img: Identifiable {
//    let id: String
//    let url: String
//}

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

struct User: Identifiable {
    let id: String
    let email: String
    let password: String
}

// MARK: - getData Class
class GetData: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var cats: [Cat] = []
    @Published var favorites: [Fav] = []
    @Published var reviews: [Review] = []
    @Published var users: [User] = []

    // MARK: - Load Cats
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

    // MARK: - Load Images
//    func loadImages() {
//        db.collection("images").getDocuments { snapshot, error in
//            if let error = error {
//                print("❌ Load Images error:", error)
//                return
//            }
//
//            self.images = snapshot?.documents.compactMap { doc in
//                let data = doc.data()
//                return Img(
//                    id: doc.documentID,
//                    url: data["url"] as? String ?? ""
//                )
//            } ?? []
//        }
//    }

    // MARK: - Load Favorites
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

    // MARK: - Load Reviews
    func loadReviews() {
        db.collection("reviews").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Reviews error:", error)
                return
            }

            self.reviews = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return Review(
                    id: doc.documentID,
                    comment: data["comment"] as? String ?? "",
                    catID: data["catID"] as? String ?? "",
                    rating: data["rating"] as? String ?? "",
                    userID: data["userID"] as? String ?? ""
                )
            } ?? []
        }
    }

    // MARK: - Load Users
    func loadUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load Users error:", error)
                return
            }

            self.users = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return User(
                    id: doc.documentID,
                    email: data["email"] as? String ?? "",
                    password: data["password"] as? String ?? ""
                )
            } ?? []
        }
    }

    // MARK: - Load All Data
    func loadAllData() {
        loadCats()
        // loadImages() // Uncomment if you implement loadImages()
        loadFavorites()
        loadReviews()
        loadUsers()
    }
}
