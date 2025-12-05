import SwiftUI
import MapKit
import CoreLocation

// ==========================================
// ส่วนที่ 1: Location Manager (ตัวจัดการ GPS)
// ==========================================
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization() // ขออนุญาต
        manager.startUpdatingLocation() // เริ่มหาพิกัด
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// ==========================================
// ส่วนที่ 2: หน้าจอเลือกแผนที่
// ==========================================
struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocationName: String
    @Binding var selectedLatitude: Double?
    @Binding var selectedLongitude: Double?
    
    // เรียกใช้ Class ด้านบน
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var placeName: String = "กำลังระบุตำแหน่ง..."
    
    var body: some View {
        ZStack {
            // 1. แผนที่
            Map(position: $position) {
                UserAnnotation() // จุดสีฟ้า (เรา)
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                // เลื่อนเสร็จ -> เก็บพิกัดและแปลงชื่อ
                let coordinate = context.camera.centerCoordinate
                selectedLatitude = coordinate.latitude
                selectedLongitude = coordinate.longitude
                getAddressFromLatLon(coordinate)
            }
            

            
            // 2. หมุดแดงตรงกลาง
            Image(systemName: "mappin")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .padding(.bottom, 40)
                .shadow(radius: 2)
            
            // 3. การ์ดด้านล่าง
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("เลื่อนหมุดไปที่จุดพบแมว")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("ระบุชื่อสถานที่", text: $placeName)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        selectedLocationName = placeName
                        dismiss()
                    }) {
                        Text("ยืนยันตำแหน่งนี้")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .navigationTitle("เลือกตำแหน่ง")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // ฟังก์ชันแปลงพิกัด -> ชื่อ
    func getAddressFromLatLon(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let _ = error {
                self.placeName = "ระบุตำแหน่งไม่ได้"
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let locality = placemark.locality ?? ""
                
                let addressParts = [name, thoroughfare, locality].filter { !$0.isEmpty }
                
                if addressParts.isEmpty {
                    self.placeName = String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
                } else {
                    self.placeName = addressParts.joined(separator: ", ")
                }
            }
            }
        }
    }

