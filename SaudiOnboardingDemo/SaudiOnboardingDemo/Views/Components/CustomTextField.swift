//
//  CustomTextField.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var errorMessage: String? = nil
    var isDisabled: Bool = false
    var showDoneButton: Bool = true
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(.plain)
                .font(.system(size: ResponsiveLayout.bodySize))
                .padding(ResponsiveLayout.baseSpacing)
                .background(isDisabled ? Color.gray.opacity(0.1) : AppColors.cardBackground)
                .cornerRadius(ResponsiveLayout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: ResponsiveLayout.cornerRadius)
                        .stroke(errorMessage != nil ? AppColors.error : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .disabled(isDisabled)
                .focused($isFocused)
                .toolbar {
                    if showDoneButton && isFocused {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button(action: {
                                hideKeyboard()
                            }) {
                                Text("تم")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(AppColors.primary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
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
        .onTapGesture {
            if isFocused {
                hideKeyboard()
            }
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var errorMessage: String? = nil
    var showDoneButton: Bool = true
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            SecureField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: ResponsiveLayout.bodySize))
                .padding(ResponsiveLayout.baseSpacing)
                .background(AppColors.cardBackground)
                .cornerRadius(ResponsiveLayout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: ResponsiveLayout.cornerRadius)
                        .stroke(errorMessage != nil ? AppColors.error : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($isFocused)
                .toolbar {
                    if showDoneButton && isFocused {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button(action: {
                                hideKeyboard()
                            }) {
                                Text("تم")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(AppColors.primary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
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
        .onTapGesture {
            if isFocused {
                hideKeyboard()
            }
        }
    }
}

struct CustomDatePicker: View {
    let title: String
    @Binding var selection: Date
    var displayedComponents: DatePickerComponents = .date
    var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            DatePicker("", selection: $selection, displayedComponents: displayedComponents)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding(ResponsiveLayout.baseSpacing)
                .background(AppColors.background)
                .cornerRadius(ResponsiveLayout.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: ResponsiveLayout.cornerRadius)
                        .stroke(errorMessage != nil ? AppColors.error : Color.gray.opacity(0.3), lineWidth: 1)
                )

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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    VStack {
        CustomTextField(title: "رقم الجوال", text: .constant(""), placeholder: "05xxxxxxxx")
        CustomTextField(title: "البريد الإلكتروني", text: .constant("test"), placeholder: "email@example.com", errorMessage: "البريد الإلكتروني غير صحيح")
        CustomSecureField(title: "كلمة المرور", text: .constant(""), placeholder: "********")
    }
    .padding()
}
