//
//  Step2_IDScanOCRView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step2_IDScanOCRView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var showIdCamera = false
    @State private var showFaceCamera = false
    @State private var isProcessingOCR = false
    @State private var isProcessingFace = false
    @State private var faceMatchResult: String = ""

    var canProceed: Bool {
        return registrationData.ocrResponse != nil && registrationData.isFaceVerified
    }

    var body: some View {
        ScrollView {
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text("تصوير الهوية والتحقق")
                        .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text("قم بتصوير هويتك الوطنية والتحقق من وجهك")
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textSecondary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // ID Section
                VStack(spacing: ResponsiveLayout.baseSpacing) {
                    SectionHeader(title: "1️⃣ تصوير الهوية")

                    if registrationData.idImage == nil {
                        CustomButton(title: "📷 تصوير الهوية (Live)") {
                            showIdCamera = true
                        }
                    } else {
                        // Image Preview
                        Image(uiImage: registrationData.idImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ResponsiveLayout.idImageHeight)
                            .cornerRadius(ResponsiveLayout.cornerRadius)

                        HStack(spacing: ResponsiveLayout.baseSpacing) {
                            CustomButton(title: "إعادة تصوير") {
                                registrationData.idImage = nil
                                registrationData.ocrResponse = nil
                            }
                            .frame(maxWidth: .infinity)

                            if registrationData.ocrResponse == nil {
                                CustomButton(title: "تأكيد و استخراج البيانات") {
                                    performOCR()
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }

                    if isProcessingOCR {
                        ProgressView("جاري استخراج البيانات...")
                            .padding(ResponsiveLayout.smallSpacing)
                    }
                }
                .responsiveCardStyle()

                // OCR Results
                if let ocrResponse = registrationData.ocrResponse {
                    VStack(alignment: .leading, spacing: ResponsiveLayout.baseSpacing) {
                        SectionHeader(title: "✅ نتائج استخراج البيانات")

                        ResultRow(label: "نوع الوثيقة", value: ocrResponse.documentType)
                        ResultRow(label: "الثقة", value: String(format: "%.0f%%", ocrResponse.confidence * 100))

                        Divider()

                        if let nationalId = ocrResponse.fields.nationalId {
                            ResultRow(label: "رقم الهوية", value: nationalId)
                        }
                        if let nameAr = ocrResponse.fields.fullNameArabic {
                            ResultRow(label: "الاسم بالعربي", value: nameAr)
                        }
                        if let nameEn = ocrResponse.fields.fullNameEnglish {
                            ResultRow(label: "الاسم بالإنجليزي", value: nameEn)
                        }
                        if let dob = ocrResponse.fields.dobHijri {
                            ResultRow(label: "تاريخ الميلاد (هجري)", value: dob)
                        }
                        if let expiry = ocrResponse.fields.expiryHijri {
                            ResultRow(label: "تاريخ الانتهاء (هجري)", value: expiry)
                        }
                        if let pob = ocrResponse.fields.placeOfBirthArabic {
                            ResultRow(label: "مكان الميلاد", value: pob)
                        }
                    }
                    .responsiveCardStyle()
                }

                // Face Match Section
                if registrationData.ocrResponse != nil {
                    VStack(spacing: ResponsiveLayout.baseSpacing) {
                        SectionHeader(title: "2️⃣ التحقق من الوجه")

                        if !registrationData.isFaceVerified {
                            Text("قم بالتقاط صورة سيلفي للتحقق من هويتك")
                                .font(.system(size: ResponsiveLayout.captionSize))
                                .foregroundColor(AppColors.textSecondary)
                                .minimumScaleFactor(0.9)
                                .lineLimit(2)

                            CustomButton(title: "📸 التقاط صورة الوجه") {
                                showFaceCamera = true
                            }

                            if isProcessingFace {
                                ProgressView("جاري التحقق...")
                                    .padding(ResponsiveLayout.smallSpacing)
                            }
                        } else {
                            HStack(spacing: ResponsiveLayout.smallSpacing) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(AppColors.success)
                                    .font(.system(size: ResponsiveLayout.titleSize))

                                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                                    Text("تم التحقق من الوجه بنجاح ✅")
                                        .font(.system(size: ResponsiveLayout.bodySize, weight: .semibold))
                                        .foregroundColor(AppColors.success)
                                        .minimumScaleFactor(0.9)
                                        .lineLimit(2)

                                    Text(faceMatchResult)
                                        .font(.system(size: ResponsiveLayout.captionSize))
                                        .foregroundColor(AppColors.textSecondary)
                                        .minimumScaleFactor(0.9)
                                        .lineLimit(2)
                                }
                            }
                            .padding(ResponsiveLayout.cardPadding)
                            .background(AppColors.success.opacity(0.1))
                            .cornerRadius(ResponsiveLayout.cornerRadius)
                        }
                    }
                    .responsiveCardStyle()
                }

                Spacer()

                // Navigation Buttons
                HStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 1
                    }, isPrimary: false)

                    CustomButton(title: "التالي") {
                        autoFillNamesAndProceed()
                    }
                    .disabled(!canProceed)
                }
            }
            .responsivePadding()
            .padding(.vertical, ResponsiveLayout.verticalPadding)
        }
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showIdCamera) {
            ImagePicker(image: $registrationData.idImage, sourceType: .camera)
        }
        .sheet(isPresented: $showFaceCamera) {
            ImagePicker(image: $registrationData.faceImage, sourceType: .camera)
                .onDisappear {
                    if registrationData.faceImage != nil {
                        performFaceMatch()
                    }
                }
        }
    }

    private func performOCR() {
        guard let image = registrationData.idImage else { return }

        isProcessingOCR = true

        Task {
            let result = await OcrService.shared.performOCR(on: image)

            await MainActor.run {
                isProcessingOCR = false

                switch result {
                case .success(let ocrResponse):
                    registrationData.ocrResponse = ocrResponse
                case .failure:
                    // Handle error
                    break
                }
            }
        }
    }

    private func performFaceMatch() {
        guard let idImage = registrationData.idImage,
              let faceImage = registrationData.faceImage else { return }

        isProcessingFace = true

        Task {
            let result = await FaceMatchService.shared.verifyFace(idImage: idImage, selfieImage: faceImage)

            await MainActor.run {
                isProcessingFace = false

                switch result {
                case .success(let matchResult):
                    if matchResult.isMatch {
                        registrationData.isFaceVerified = true
                        faceMatchResult = matchResult.message
                    }
                case .failure:
                    // Handle error
                    break
                }
            }
        }
    }

    private func autoFillNamesAndProceed() {
        // Auto-fill names from OCR
        if let ocrResponse = registrationData.ocrResponse {
            if let nameAr = ocrResponse.fields.fullNameArabic, !nameAr.isEmpty {
                registrationData.fullNameArabic = nameAr
                registrationData.isArabicNameFromOCR = true
            }
            if let nameEn = ocrResponse.fields.fullNameEnglish, !nameEn.isEmpty {
                registrationData.fullNameEnglish = nameEn
                registrationData.isEnglishNameFromOCR = true
            }
        }

        // Move to next step
        registrationData.currentStep = 3
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: ResponsiveLayout.subtitleSize, weight: .bold))
            .foregroundColor(AppColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .minimumScaleFactor(0.8)
            .lineLimit(1)
    }
}

struct ResultRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: ResponsiveLayout.smallSpacing) {
            Text(label)
                .font(.system(size: ResponsiveLayout.bodySize))
                .foregroundColor(AppColors.textSecondary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            Spacer()
            Text(value)
                .font(.system(size: ResponsiveLayout.bodySize, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(2)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    Step2_IDScanOCRView()
        .environmentObject(RegistrationData())
}
