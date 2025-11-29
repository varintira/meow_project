import SwiftUI

struct CatDetailView: View {
    let cat: Cat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // 1. รูปภาพ Cover
                AsyncImage(url: cat.img) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
                
                // 2. ส่วนเนื้อหา
                VStack(alignment: .leading, spacing: 16) {
                    
                    // ชื่อและเพศ
                    HStack {
                        Text(cat.name).font(.system(size: 32, weight: .bold))
                        Spacer()
                        Text(cat.gender)
                            .font(.subheadline).fontWeight(.semibold)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(cat.gender.lowercased() == "male" ? Color.blue.opacity(0.1) : Color.pink.opacity(0.1))
                            .foregroundColor(cat.gender.lowercased() == "male" ? .blue : .pink)
                            .cornerRadius(20)
                    }
                    
                    Divider()
                    
                    // ข้อมูลต่างๆ
                    HStack(alignment: .top) {
                        Image(systemName: "mappin.and.ellipse").foregroundColor(.red).font(.title3)
                        VStack(alignment: .leading) {
                            Text("สถานที่พบ").font(.caption).foregroundColor(.gray)
                            Text(cat.locationFound).font(.body)
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "face.smiling").foregroundColor(.orange).font(.title3)
                        VStack(alignment: .leading) {
                            Text("นิสัยน้อง").font(.caption).foregroundColor(.gray)
                            Text(cat.temperament).font(.body)
                        }
                    }
                    
                    Divider()
                    
                    // รายละเอียด
                    VStack(alignment: .leading, spacing: 8) {
                        Text("รายละเอียดเพิ่มเติม").font(.headline)
                        Text(cat.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // -------------------------------------------------
                    // ปุ่ม Location (NavigationLink)
                    // -------------------------------------------------
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
                .padding(24) // Padding นี้ครอบคลุมเนื้อหาทั้งหมดรวมถึงปุ่มด้วย
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}


