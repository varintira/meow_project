import SwiftUI

struct CatCardView: View {
    let cat: Cat

    var body: some View {
        HStack(spacing: 16) {
            // ------------------------------------------------------------
            // (จุดที่แก้ไข) เปลี่ยนจาก AsyncImage เป็น SmartImageView
            // ------------------------------------------------------------
            // หมายเหตุ: cat.img ต้องเป็น String นะครับ (ตามที่แก้ใน Model)
            SmartImageView(imgString: cat.img)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            // ------------------------------------------------------------
            
            // --- ส่วนข้อความ (เหมือนเดิม) ---
            VStack(alignment: .leading, spacing: 6) {
                Text(cat.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("Gender: \(cat.gender)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Found at: \(cat.locationFound)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer() // ดันเนื้อหาไปชิดซ้าย
        }
        .padding(20) // ระยะห่างภายในกรอบ
        .frame(maxWidth: .infinity) // ขยายเต็มความกว้างจอ
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
