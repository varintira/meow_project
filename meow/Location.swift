import SwiftUI

struct LocationView: View {
    let locationName: String // รับชื่อสถานที่มา
    
    var body: some View {
        VStack(spacing: 20) {
            // ไอคอนแผนที่
            Image(systemName: "map.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue.opacity(0.8))
                .padding(.top, 50)
            
            Text("พิกัดที่พบน้อง")
                .font(.title2)
                .fontWeight(.bold)
            
            // แสดงชื่อสถานที่
            Text(locationName)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("แผนที่")
        .navigationBarTitleDisplayMode(.inline)
    }
}
