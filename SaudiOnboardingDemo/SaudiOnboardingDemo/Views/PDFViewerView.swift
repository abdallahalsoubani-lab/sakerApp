//
//  PDFViewerView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdfName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if let pdfURL = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
                    PDFKitView(url: pdfURL)
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("لم يتم العثور على الملف")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("من نحن")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update needed
    }
}

#Preview {
    PDFViewerView(pdfName: "AboutUs")
}
