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
    @Environment(\.dismiss) var dismiss

    init(coordinate: Binding<CLLocationCoordinate2D?>) {
        self._coordinate = coordinate
        // Default to Riyadh, Saudi Arabia
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
        self._region = State(initialValue: MKCoordinateRegion(
            center: coordinate.wrappedValue ?? defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
        self._selectedLocation = State(initialValue: coordinate.wrappedValue ?? defaultCoordinate)
    }

    var body: some View {
        VStack(spacing: ResponsiveLayout.baseSpacing) {
            // Header
            HStack {
                Text("موقع المنزل")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("إغلاق")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Map with center pin
            ZStack {
                Map(coordinateRegion: $region)
                    .frame(height: 400)
                    .cornerRadius(AppConstants.cornerRadius)
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                selectedLocation = region.center
                            }
                    )
                    .simultaneousGesture(
                        MagnificationGesture()
                            .onChanged { _ in
                                selectedLocation = region.center
                            }
                    )
                
                // Center pin that stays in the middle
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primary)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            .padding(.horizontal)
            .onAppear {
                selectedLocation = region.center
            }

            // Coordinates display
            if let location = selectedLocation {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppColors.primary)
                    Text("الإحداثيات:")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                    Text(String(format: "%.4f, %.4f", location.latitude, location.longitude))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                }
                .padding(.horizontal)
            }

            // Confirm button
            CustomButton(title: "تأكيد الموقع") {
                coordinate = selectedLocation
                dismiss()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(UIColor.systemBackground))
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
