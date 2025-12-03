import SwiftUI
import FirebaseFirestore
import PhotosUI
import MapKit

struct AddCatView: View {
    // ... (ตัวแปรอื่นๆ เหมือนเดิม) ...
    @State private var name: String = ""
    @State private var locationFound: String = ""
    @State private var gender: String = "Male"
    @State private var temperament: String = ""
    @State private var description: String = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                // ... (ส่วน UI เหมือนเดิมเป๊ะ ไม่ต้องแก้) ...
                Section(header: Text("รูปน้องแมว")) {
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable().scaledToFill()
                                .frame(height: 200).frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 150)
                                .overlay(Text("กดเพื่อเพิ่มรูปภาพ").foregroundColor(.gray))
                        }
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text(selectedImage == nil ? "เลือกรูปภาพ" : "เปลี่ยนรูป")
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.blue.opacity(0.1)).cornerRadius(10)
                        }
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
                
                Section(header: Text("ข้อมูลทั่วไป")) {
                    TextField("ชื่อน้องแมว", text: $name)
                    
                    NavigationLink(destination: LocationPickerView(selectedLocationName: $locationFound)) {
                        HStack {
                            Text(locationFound.isEmpty ? "เลือกสถานที่..." : locationFound)
                            Spacer()
                            Image(systemName: "map.fill").foregroundColor(.blue)
                        }
                    }
                    
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
                        if isLoading { ProgressView() } else { Text("บันทึกข้อมูล").foregroundColor(.white).bold() }
                    }
                    .disabled(isLoading)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("เพิ่มแมวใหม่")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("ยกเลิก") { dismiss() } }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("แจ้งเตือน"), message: Text(alertMessage), dismissButton: .default(Text("ตกลง")) {
                    if alertMessage.contains("สำเร็จ") { dismiss() }
                })
            }
        }
    }
    
    // --- ฟังก์ชันบันทึก (แก้ใหม่ ไม่ใช้ Storage) ---
    func saveCatProcess() {
        guard !name.isEmpty, !locationFound.isEmpty else {
            alertMessage = "กรุณากรอกชื่อและสถานที่"
            showAlert = true
            return
        }
        isLoading = true
        
        var imageString = "https://placekitten.com/300/300" // ค่า Default
        
        // ถ้ามีรูป -> แปลงเป็น Base64 String
        if let image = selectedImage {
            // สำคัญ! ต้องบีบอัดรูปให้เล็กที่สุด (0.1) ไม่งั้นเกิน 1MB แล้ว Firestore จะ Error
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                let base64 = imageData.base64EncodedString()
                imageString = base64
            }
        }
        
        // บันทึกลง Firestore เลย
        let db = Firestore.firestore()
        let newCatData: [String: Any] = [
            "name": name,
            "locationFound": locationFound,
            "gender": gender,
            "temperament": temperament,
            "description": description,
            "img": imageString, // เก็บเป็นข้อความยาวๆ แทน URL
            "createdBy": "GuestUser",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("cats").addDocument(data: newCatData) { error in
            isLoading = false
            if let error = error {
                alertMessage = "ไม่สำเร็จ: \(error.localizedDescription)"
            } else {
                alertMessage = "บันทึกข้อมูลสำเร็จ!"
            }
            showAlert = true
        }
    }
}
