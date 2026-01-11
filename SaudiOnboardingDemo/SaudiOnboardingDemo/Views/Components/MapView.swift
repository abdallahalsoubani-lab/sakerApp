//
//  MapView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var coordinate: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion
    @State private var selectedLocation: CLLocationCoordinate2D?

    init(coordinate: Binding<CLLocationCoordinate2D?>) {
        self._coordinate = coordinate
        // Default to Riyadh, Saudi Arabia
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
        self._region = State(initialValue: MKCoordinateRegion(
            center: coordinate.wrappedValue ?? defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
        self._selectedLocation = State(initialValue: coordinate.wrappedValue)
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: selectedLocation != nil ? [MapMarker(coordinate: selectedLocation!)] : []) { item in
                MapPin(coordinate: item.coordinate, tint: AppColors.primary)
            }
            .frame(height: 300)
            .cornerRadius(AppConstants.cornerRadius)
            .onTapGesture {
                // يمكن تطوير هذا لإضافة Tap Gesture لتحديد الموقع
            }

            if selectedLocation != nil {
                HStack {
                    Text("الإحداثيات:")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(String(format: "%.4f, %.4f", selectedLocation!.latitude, selectedLocation!.longitude))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.top, 8)
            }

            CustomButton(title: "تأكيد الموقع") {
                coordinate = selectedLocation
            }
            .padding(.top)
        }
    }
}

struct MapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
//
//#Preview {
//    @Previewable @State var coordinate: CLLocationCoordinate2D? = nil
//    MapView(coordinate: $coordinate)
//        .padding()
//}
