import SwiftUI
import MapKit
import CoreLocation

struct LocationView: View {
    let locationName: String // ชื่อสถานที่ (เช่น "สยามพารากอน")
    
    // เก็บพิกัดของแมว (จะได้จากการแปลงชื่อสถานที่)
    @State private var catCoordinate: CLLocationCoordinate2D?
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // --- 1. ส่วนแผนที่ ---
            Map(position: $position) {
                // ถ้าแปลงชื่อเป็นพิกัดได้ ให้ปักหมุดสีแดงตรงจุดนั้น
                if let coordinate = catCoordinate {
                    Marker(locationName, coordinate: coordinate)
                        .tint(.red)
                }
                
                // แสดงจุดสีฟ้า (ตำแหน่งเรา)
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            // เมื่อหน้าจอโผล่ขึ้นมา ให้เริ่มแปลงชื่อเป็นพิกัดทันที
            .onAppear {
                geocodeAddress(address: locationName)
            }
            
            // --- 2. ส่วนการ์ดแสดงรายละเอียด (ด้านล่าง) ---
            VStack(spacing: 10) {
                // ขีดเล็กๆ ด้านบนการ์ด (ให้ดูเหมือน Sheet)
                Rectangle()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                HStack(alignment: .top) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("พิกัดที่พบน้อง")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(locationName)
                            .font(.headline)
                            .lineLimit(2)
                        
                        // --- ปุ่มนำทาง (กดแล้วเปิด Apple Maps) ---
                        if let coordinate = catCoordinate {
                            Button(action: {
                                openMapForDirections(coordinate: coordinate, name: locationName)
                            }) {
                                Label("นำทางไปหาน้อง", systemImage: "car.fill")
                                    .font(.caption.bold())
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 4)
                        }
                        // ---------------------------------------
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding() // เว้นระยะขอบจอ
        }
        .navigationTitle("แผนที่")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // --- ฟังก์ชัน 1: แปลง ชื่อสถานที่ -> พิกัด (Geocoding) ---
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                // เจอพิกัดแล้ว!
                let coordinate = location.coordinate
                self.catCoordinate = coordinate
                
                // สั่งกล้องให้ซูมไปหาพิกัดนั้น
                withAnimation {
                    self.position = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // ซูมเข้าไปใกล้ๆ
                    ))
                }
            } else {
                print("หาพิกัดไม่เจอ: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // --- ฟังก์ชัน 2: เปิด Apple Maps เพื่อนำทาง ---
    func openMapForDirections(coordinate: CLLocationCoordinate2D, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // ชื่อสถานที่จะไปโชว์ใน Apple Maps
        
        // สั่งเปิดโหมดขับรถ (Driving)
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    LocationView(locationName: "สยามพารากอน")
}
