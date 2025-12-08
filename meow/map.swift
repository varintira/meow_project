import SwiftUI
import MapKit
import CoreLocation

struct LocationView: View {
    let locationName: String // รับแค่ชื่อสถานที่ (เช่น "สยามพารากอน") พอ ไม่ต้องเอาพิกัด
    let latitude: Double?
    let longitude: Double?
    
    // ตัวแปรสำหรับคุมแผนที่
    @State private var position = MapCameraPosition.automatic
    @State private var markerCoordinate: CLLocationCoordinate2D? // เก็บพิกัดหมุดแดง
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // --- 1. แผนที่ ---
            Map(position: $position) {
                
                if let coordinate = markerCoordinate {
                    Marker(locationName, coordinate: coordinate)
                        .tint(.red)
                }
                
                // แสดงจุดสีฟ้า (ตัวเรา)
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            // พอหน้าจอเปิดปุ๊บ ให้เริ่มแปลงชื่อเป็นพิกัดทันที
            .onAppear {
                if let lat = latitude, let long = longitude {
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    self.markerCoordinate = coordinate
                    self.position = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    ))
                } else {
                    findLocationFromName(name: locationName)
                }
            }
            
            // --- 2. การ์ดด้านล่าง ---
            VStack(spacing: 10) {
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
                        
                        // ปุ่มกดนำทาง
                        if let coordinate = markerCoordinate {
                            Button(action: {
                                openMaps(coordinate: coordinate, name: locationName)
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
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
        .navigationTitle("แผนที่")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    func findLocationFromName(name: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                // เจอพิกัดแล้ว!
                let coordinate = location.coordinate
                self.markerCoordinate = coordinate
                
                // สั่งกล้องซูมไปหาเลย
                withAnimation {
                    self.position = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    ))
                }
            } else {
                print("หาไม่เจอ: \(error?.localizedDescription ?? "Unknown")")
            }
        }
    }
    
    // ฟังก์ชันเปิด Apple Maps
    func openMaps(coordinate: CLLocationCoordinate2D, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    LocationView(locationName: "Central World", latitude: nil, longitude: nil)
}
