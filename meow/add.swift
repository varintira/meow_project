import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct AddCatView: View {
    // --- ตัวแปรสำหรับเก็บข้อมูล ---
    @State private var name: String = ""
    @State private var locationFound: String = "" // รอรับค่าจากหน้าแผนที่
    @State private var gender: String = "Male"
    @State private var temperament: String = ""
    @State private var description: String = ""
    
    // --- ตัวแปรสำหรับรูปภาพ ---
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    // --- ตัวแปรจัดการหน้าจอ ---
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                // 1. ส่วนเลือกรูปภาพ
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
                                        Text("กดเพื่อเพิ่มรูปภาพ").foregroundColor(.gray)
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
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
                
                // 2. ข้อมูลทั่วไป
                Section(header: Text("ข้อมูลทั่วไป")) {
                    TextField("ชื่อน้องแมว", text: $name)
                    
                    // --- ปุ่มกดไปหน้าแผนที่ ---
                    NavigationLink(destination: LocationPickerView(selectedLocationName: $locationFound)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("สถานที่พบ")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                if locationFound.isEmpty {
                                    Text("แตะเพื่อเลือกบนแผนที่...")
                                        .foregroundColor(.blue)
                                } else {
                                    Text(locationFound)
                                        .fontWeight(.medium)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                            Image(systemName: "map.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    
                    Picker("เพศ", selection: $gender) {
                        Text("ตัวผู้").tag("Male")
                        Text("ตัวเมีย").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                
                // 3. รายละเอียด
                Section(header: Text("รายละเอียด")) {
                    TextField("นิสัย", text: $temperament)
                    TextEditor(text: $description).frame(height: 100)
                }
                
                // 4. ปุ่มบันทึก
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
    
    // --- ฟังก์ชันบันทึก ---
    func saveCatProcess() {
        guard !name.isEmpty, !locationFound.isEmpty else {
            alertMessage = "กรุณากรอกชื่อและเลือกสถานที่พบ"
            showAlert = true
            return
        }
        isLoading = true
        
        if let image = selectedImage {
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
            saveDataToFirestore(imageURL: "https://placekitten.com/300/300")
        }
    }
    
    func uploadImageToFirebase(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        let filename = "cats/\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child(filename)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }
    
    func saveDataToFirestore(imageURL: String) {
        let db = Firestore.firestore()
        let newCatData: [String: Any] = [
            "name": name,
            "locationFound": locationFound,
            "gender": gender,
            "temperament": temperament,
            "description": description,
            "img": imageURL,
            "createdBy": "GuestUser",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("cats").addDocument(data: newCatData) { error in
            isLoading = false
            if let error = error {
                alertMessage = "บันทึกไม่สำเร็จ: \(error.localizedDescription)"
            } else {
                alertMessage = "บันทึกข้อมูลสำเร็จ!"
            }
            showAlert = true
        }
    }
}
