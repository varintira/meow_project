//import SwiftUI
//import FirebaseFirestore
//
//struct ContentView: View {
//    let db = Firestore.firestore()
//    
//    var body: some View {
//        Button("Add 5 Cats") {
//            addCats()
//        }
//        .padding()
//    }
//    
//    func addCats() {
//        // สมมติ userId ของคนสร้าง
//        let userId = "abc123" // ใส่ userId จริงจาก collection users
//        
//        // Array ของแมว 5 ตัว
//        let cats = [
//            [
//                "name": "Milo",
//                "gender": "Male",
//                "locationFound": "Park",
//                "description": "Friendly and playful",
//                "temperament": "Calm",
//                "createdBy": db.collection("users").document(userId),
//                "createdAt": Timestamp()
//            ],
//            [
//                "name": "Luna",
//                "gender": "Female",
//                "locationFound": "Street",
//                "description": "Shy and quiet",
//                "temperament": "Shy",
//                "createdBy": db.collection("users").document(userId),
//                "createdAt": Timestamp()
//            ],
//            [
//                "name": "Leo",
//                "gender": "Male",
//                "locationFound": "Alley",
//                "description": "Very active",
//                "temperament": "Energetic",
//                "createdBy": db.collection("users").document(userId),
//                "createdAt": Timestamp()
//            ],
//            [
//                "name": "Bella",
//                "gender": "Female",
//                "locationFound": "Garden",
//                "description": "Sweet and gentle",
//                "temperament": "Friendly",
//                "createdBy": db.collection("users").document(userId),
//                "createdAt": Timestamp()
//            ],
//            [
//                "name": "Simba",
//                "gender": "Male",
//                "locationFound": "Home",
//                "description": "Curious and playful",
//                "temperament": "Active",
//                "createdBy": db.collection("users").document(userId),
//                "createdAt": Timestamp()
//            ]
//        ]
//        
//        // เพิ่มแมวแต่ละตัวลง Firestore
//        for cat in cats {
//            db.collection("cats").addDocument(data: cat) { error in
//                if let error = error {
//                    print("❌ Error adding cat: \(error)")
//                } else {
//                    print("✅ Cat added successfully!")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
