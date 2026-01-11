//
//  CustomPicker.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct CustomPicker<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            Menu {
                ForEach(Array(T.allCases), id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .font(.system(size: ResponsiveLayout.bodySize))
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .font(.system(size: ResponsiveLayout.bodySize))
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection.rawValue)
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textPrimary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: ResponsiveLayout.captionSize))
                }
                .padding(ResponsiveLayout.baseSpacing)
                .background(AppColors.background)
                .cornerRadius(ResponsiveLayout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: ResponsiveLayout.cornerRadius)
                        .stroke(errorMessage != nil ? AppColors.error : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: ResponsiveLayout.captionSize))
                    .foregroundColor(AppColors.error)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    @Previewable @State var nationality: Nationality = .saudi
//    CustomPicker(title: "الجنسية", selection: $nationality)
//        .padding()
//}
