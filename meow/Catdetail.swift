import SwiftUI

struct CatDetailView: View {
    let cat: Cat
    
    // รับ dataStore เข้ามาเพื่อใช้งานปุ่มหัวใจ
    @ObservedObject var dataStore: GetData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // --- 1. รูปภาพ Cover ---
                AsyncImage(url: cat.img) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // --- 2. เนื้อหา ---
                VStack(alignment: .leading, spacing: 16) {
                    
                    // ชื่อและเพศ
                    HStack {
                        Text(cat.name)
                            .font(.system(size: 32, weight: .bold))
                        
                        Spacer()
                        
                        Text(cat.gender)
                            .font(.subheadline).fontWeight(.semibold)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(cat.gender.lowercased() == "male" ? Color.blue.opacity(0.1) : Color.pink.opacity(0.1))
                            .foregroundColor(cat.gender.lowercased() == "male" ? .blue : .pink)
                            .cornerRadius(20)
                    }
                    
                    Divider()
                    
                    // ข้อมูลสถานที่พบ
                    HStack(alignment: .top) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                            .font(.title3)
                        VStack(alignment: .leading) {
                            Text("สถานที่พบ")
                                .font(.caption).foregroundColor(.gray)
                            Text(cat.locationFound)
                                .font(.body)
                        }
                    }
                    
                    // ข้อมูลนิสัย
                    HStack(alignment: .top) {
                        Image(systemName: "face.smiling")
                            .foregroundColor(.orange)
                            .font(.title3)
                        VStack(alignment: .leading) {
                            Text("นิสัยน้อง")
                                .font(.caption).foregroundColor(.gray)
                            Text(cat.temperament)
                                .font(.body)
                        }
                    }
                    
                    Divider()
                    
                    // รายละเอียดเพิ่มเติม
                    VStack(alignment: .leading, spacing: 8) {
                        Text("รายละเอียดเพิ่มเติม").font(.headline)
                        Text(cat.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // --- ปุ่ม Location (ไปหน้าแผนที่) ---
                    NavigationLink(destination: LocationView(locationName: cat.locationFound)) {
                        Text("ดูตำแหน่งที่พบ (Location)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                    
                }
                .padding(24) // ระยะห่างขอบซ้ายขวาของเนื้อหา
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        
        // --- 3. ส่วน Toolbar (ปุ่มหัวใจ) ---
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // สั่งสลับสถานะ Fav
                    dataStore.toggleFavorite(cat)
                }) {
                    // เปลี่ยนรูปและสีตามสถานะ
                    Image(systemName: dataStore.isFavorite(cat) ? "heart.fill" : "heart")
                        .foregroundColor(dataStore.isFavorite(cat) ? .red : .gray)
                        .font(.title2)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.6)))
                }
            }
        }
    }
}
