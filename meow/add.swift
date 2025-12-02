import SwiftUI
import FirebaseFirestore
import FirebaseStorage // (1) อย่าลืม import ตัวนี้
import PhotosUI

struct AddCatView: View {
    // ข้อมูลแมว
    @State private var name: String = ""
    @State private var locationFound: String = ""
    @State private var gender: String = "Male"
    @State private var temperament: String = ""
    @State private var description: String = ""
    
    // รูปภาพ
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    // สถานะหน้าจอ
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                // --- ส่วนรูปภาพ ---
                Section(header: Text("รูปน้องแมว")) {
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 150)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue)
                                        Text("กดเพื่อเพิ่มรูปภาพ")
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text(selectedImage == nil ? "เลือกรูปภาพ" : "เปลี่ยนรูป")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical)
                }
                // (2) แก้ onChange ให้รองรับ iOS 17+
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
                
                // --- ข้อมูลทั่วไป ---
                Section(header: Text("ข้อมูลทั่วไป")) {
                    TextField("ชื่อน้องแมว", text: $name)
                    TextField("สถานที่พบ", text: $locationFound)
                    Picker("เพศ", selection: $gender) {
                        Text("ตัวผู้").tag("Male")
                        Text("ตัวเมีย").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("รายละเอียด")) {
                    TextField("นิสัย", text: $temperament)
                    TextEditor(text: $description).frame(height: 100)
                }
                
                Section {
                    Button(action: saveCatProcess) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("บันทึกข้อมูล")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(isLoading)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("เพิ่มแมวใหม่ 🐱")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ยกเลิก") { dismiss() }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("แจ้งเตือน"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("ตกลง")) {
                        if alertMessage.contains("สำเร็จ") { dismiss() }
                    }
                )
            }
        }
    }
    
    // --- ฟังก์ชันหลัก: เริ่มกระบวนการบันทึก ---
    func saveCatProcess() {
        guard !name.isEmpty, !locationFound.isEmpty else {
            alertMessage = "กรุณากรอกชื่อและสถานที่พบ"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // 1. เช็คว่ามีรูปไหม?
        if let image = selectedImage {
            // ถ้ามีรูป -> อัปโหลดรูปก่อน -> ได้ลิ้งค์ -> ค่อยเซฟลง DB
            uploadImageToFirebase(image) { urlString in
                if let url = urlString {
                    saveDataToFirestore(imageURL: url)
                } else {
                    isLoading = false
                    alertMessage = "อัปโหลดรูปไม่สำเร็จ"
                    showAlert = true
                }
            }
        } else {
            // ถ้าไม่มีรูป -> ใช้รูป Default -> เซฟเลย
            saveDataToFirestore(imageURL: "https://placekitten.com/300/300")
        }
    }
    
    // --- ฟังก์ชันย่อย 1: อัปโหลดรูปไป Firebase Storage ---
    func uploadImageToFirebase(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // บีบอัดรูปเป็น JPEG คุณภาพ 0.8
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        // ตั้งชื่อไฟล์ (ใช้ UUID เพื่อไม่ให้ชื่อซ้ำ)
        let filename = "cats/\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child(filename)
        
        // สั่งอัปโหลด
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // อัปโหลดเสร็จ -> ขอ URL
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString) // ส่ง URL กลับไปแบบ String
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    // --- ฟังก์ชันย่อย 2: บันทึกข้อมูลลง Firestore ---
    func saveDataToFirestore(imageURL: String) {
        let db = Firestore.firestore()
        
        let newCatData: [String: Any] = [
            "name": name,
            "locationFound": locationFound,
            "gender": gender,
            "temperament": temperament,
            "description": description,
            "img": imageURL, // ลิ้งค์รูปที่ได้จาก Storage
            "createdBy": "GuestUser",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("cats").addDocument(data: newCatData) { error in
            isLoading = false
            if let error = error {
                alertMessage = "บันทึกข้อมูลไม่สำเร็จ: \(error.localizedDescription)"
            } else {
                alertMessage = "บันทึกข้อมูลสำเร็จ!"
            }
            showAlert = true
        }
    }
}


