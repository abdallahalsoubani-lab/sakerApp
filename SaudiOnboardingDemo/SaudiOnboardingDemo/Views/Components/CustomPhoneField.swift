//
//  CustomPhoneField.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct CustomPhoneField: View {
    let title: String
    @Binding var phoneNumber: String
    @Binding var selectedCountry: Country
    var placeholder: String = "5xxxxxxxx"
    var errorMessage: String? = nil
    @FocusState private var isFocused: Bool
    @State private var showCountryPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            HStack(spacing: ResponsiveLayout.smallSpacing) {
                // Phone Number TextField
                TextField(placeholder, text: $phoneNumber)
                    .keyboardType(.phonePad)
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
                        if isFocused {
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
                
                // Country Code Dropdown
                Button(action: {
                    showCountryPicker = true
                    hideKeyboard()
                }) {
                    HStack(spacing: 6) {
                        Text(selectedCountry.flag)
                            .font(.system(size: 24))
                        
                        Text(selectedCountry.dialCode)
                            .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, ResponsiveLayout.baseSpacing)
                    .background(AppColors.cardBackground)
                    .cornerRadius(ResponsiveLayout.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: ResponsiveLayout.cornerRadius)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: ResponsiveLayout.captionSize))
                    .foregroundColor(AppColors.error)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(selectedCountry: $selectedCountry, isPresented: $showCountryPicker)
        }
    }
}

struct CountryPickerView: View {
    @Binding var selectedCountry: Country
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List(Country.allCountries) { country in
                Button(action: {
                    selectedCountry = country
                    isPresented = false
                }) {
                    HStack(spacing: ResponsiveLayout.baseSpacing) {
                        Text(country.flag)
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(country.nameArabic)
                                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(country.name)
                                .font(.system(size: ResponsiveLayout.captionSize))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Text(country.dialCode)
                            .font(.system(size: ResponsiveLayout.bodySize, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                        
                        if selectedCountry.code == country.code {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.primary)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(AppColors.cardBackground)
            }
            .listStyle(.plain)
            .navigationTitle("اختر الدولة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("إغلاق") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
            .background(AppColors.background)
            .scrollContentBackground(.hidden)
        }
        .preferredColorScheme(ThemeManager.shared.isDarkMode ? .dark : .light)
    }
}

#Preview {
    VStack {
        CustomPhoneField(
            title: "رقم الجوال *",
            phoneNumber: .constant(""),
            selectedCountry: .constant(Country.saudiArabia),
            placeholder: "5xxxxxxxx"
        )
        
        CustomPhoneField(
            title: "رقم الجوال *",
            phoneNumber: .constant("555123456"),
            selectedCountry: .constant(Country.saudiArabia),
            placeholder: "5xxxxxxxx",
            errorMessage: "رقم الجوال غير صحيح"
        )
    }
    .padding()
    .background(AppColors.background)
}
