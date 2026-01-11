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
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                ForEach(Array(T.allCases), id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        HStack {
                            Text(option.rawValue)
                            if selection == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection.rawValue)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 12))
                }
                .padding()
                .background(AppColors.background)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? AppColors.error : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(AppColors.error)
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
