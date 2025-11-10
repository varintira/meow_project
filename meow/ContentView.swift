import SwiftUI
import MapKit // (A) 1. Import MapKit
import CoreLocation // (A) 2. Import CoreLocation

// (B) 3. ปรับ Model ให้ง่ายขึ้น: ลบ Hashable ออก แต่ยังคง Identifiable ไว้
struct Cat: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D // <-- พิกัด
    let detail: String
    let sex: Bool
}

// (C) 4. Data
let sampleCats: [Cat] = [
    Cat(name: "เจ้าสามสี", location: "สะพานข้ามคลอง", imageName: "cat.fill",
        coordinate: .init(latitude: 13.74727, longitude: 100.56591),detail: "ตัวที่ 1 ของเรา", sex: true ),
    Cat(name: "น้องส้ม", location: "เชียงใหม่", imageName: "pawprint.fill",
        coordinate: .init(latitude: 18.7883, longitude: 98.9853),detail: "ตัวที่ 2 ของเรา", sex: false ),
    Cat(name: "ดุ๊กดิ๊ก", location: "ภูเก็ต", imageName: "fish.fill",
        coordinate: .init(latitude: 7.8804, longitude: 98.3922),detail: "ตัวที่ 3 ของเรา", sex: true ),
    Cat(name: "มอมแมม", location: "ขอนแก่น", imageName: "tortoise.fill",
        coordinate: .init(latitude: 16.4383, longitude: 102.8333),detail: "ตัวที่ 2 ของเรา", sex: false)
]

// ----------------------------------------------------------------------

// (D) 5. DetailView (ไม่เปลี่ยนแปลง) ข้างในการ์ด
struct CatDetailView: View {
    let cat: Cat
    
    @State private var cameraPosition: MapCameraPosition
    
    init(cat: Cat) {
        self.cat = cat
        // คำนวณ Region สำหรับแผนที่
        let region = MKCoordinateRegion(
            center: cat.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        )
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- 1. ส่วนครึ่งบน (ข้อมูล) ---
            HStack(alignment:.center, spacing: 16) {
                Image(systemName: cat.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.orange)
                    .padding(.top)
                    Spacer() //ชิดซ้าย
            
                VStack (alignment:.leading){
                    Text(cat.name)
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text(cat.location)
                        
                    }
                    Text (cat.detail)
                    Text(cat.sex ? "ชาย" : "หญิง")
                    
                }
                Spacer() //ชิดซ้าย
            }
                        .frame(maxWidth: 350)
                        .frame(height: 200)
            .padding(10)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
            // --- 2. ส่วนครึ่งล่าง (แผนที่) ---
            HStack{ Map(position: $cameraPosition) {
                // ปักหมุด
                Marker(cat.name, systemImage: "pawprint.fill", coordinate: cat.coordinate)
                    .tint(.orange)
            }
                            .ignoresSafeArea(edges: .bottom)
            }
            .padding(.top, 50)
        }
        .navigationTitle(cat.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ----------------------------------------------------------------------

// 4. Card View (ไม่เปลี่ยนแปลง)
struct CatCardView: View {
    let cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: cat.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .foregroundColor(.white)
                .background(Color.orange.opacity(0.7))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cat.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(cat.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
        
    }
}

// ----------------------------------------------------------------------

// 5. Content View: หน้าหลัก (ปรับปรุงการนำทาง)
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(sampleCats) { cat in
                        // **(E) เปลี่ยนการนำทาง:** ใช้ NavigationLink(destination:...) แทน NavigationLink(value:...)
                        NavigationLink(destination: CatDetailView(cat: cat)) {
                            CatCardView(cat: cat)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("เหล่าแมวเหมียว")
            // ลบ .navigationDestination(for:...) ออก เนื่องจากใช้ NavigationLink(destination:...) แล้ว
            .background(Color(.systemGroupedBackground))
        }
    }
}


#Preview("Main View") {
    ContentView()
}
