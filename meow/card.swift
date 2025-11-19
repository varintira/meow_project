import SwiftUI

struct CatCardView: View {
    let cat: Cat

    var body: some View {
        HStack(spacing: 16) { // ปรับ spacing ให้กระชับขึ้น (50 กว้างไป)
            
            // --- ส่วนรูปภาพ ---
            AsyncImage(url:cat.img) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3) // สีเทาตอนโหลด
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // --- ส่วนข้อความ ---
            VStack(alignment: .leading, spacing: 6) {
                Text(cat.name)
                    .font(.headline)
                    .lineLimit(1) // ป้องกันชื่อยาวเกิน
                
                Text("Gender: \(cat.gender)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Found at: \(cat.locationFound)")
                    .font(.caption) // ปรับขนาดให้เหมาะสม
                    .foregroundColor(.blue)
            }
            
            Spacer() // ดันเนื้อหาไปชิดซ้าย
        }
        .padding() // ระยะห่างภายในกรอบ
        .frame(maxWidth: .infinity) // ขยายเต็มความกว้างจอ
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
