//
//  ImagePicker.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI
import UIKit
import AVFoundation

// MARK: - Camera Type
enum CameraType {
    case idCard
    case face
    case general
}

// MARK: - Enhanced Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    var cameraType: CameraType = .general

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        // Set front camera for face photos
        if cameraType == .face && sourceType == .camera {
            picker.cameraDevice = .front
        } else {
            picker.cameraDevice = .rear
        }
        
        // Add overlay for face/ID frames
        if sourceType == .camera {
            let overlayView = CameraOverlayView(cameraType: cameraType)
            picker.cameraOverlayView = overlayView
            picker.showsCameraControls = true
        }
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Camera Overlay View
class CameraOverlayView: UIView {
    let cameraType: CameraType
    
    init(cameraType: CameraType) {
        self.cameraType = cameraType
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Clear the entire context
        context.clear(rect)
        
        // Draw semi-transparent black background
        UIColor.black.withAlphaComponent(0.5).setFill()
        context.fill(rect)
        
        // Calculate frame dimensions
        let frameRect: CGRect
        switch cameraType {
        case .face:
            // Oval frame for face
            let width: CGFloat = rect.width * 0.65
            let height: CGFloat = width * 1.3
            let x = (rect.width - width) / 2
            let y = (rect.height - height) / 2 - 50
            frameRect = CGRect(x: x, y: y, width: width, height: height)
            
            // Clear oval area
            context.setBlendMode(.clear)
            let ovalPath = UIBezierPath(ovalIn: frameRect)
            ovalPath.fill()
            
            // Draw golden border
            context.setBlendMode(.normal)
            UIColor(red: 0.831, green: 0.686, blue: 0.216, alpha: 1.0).setStroke()
            context.setLineWidth(3)
            ovalPath.stroke()
            
            // Draw guide text
            drawText("ضع وجهك في الإطار", at: CGPoint(x: rect.midX, y: frameRect.maxY + 30), in: context)
            
        case .idCard:
            // Rectangle frame for ID card
            let width: CGFloat = rect.width * 0.85
            let height: CGFloat = width * 0.63 // ID card ratio
            let x = (rect.width - width) / 2
            let y = (rect.height - height) / 2
            frameRect = CGRect(x: x, y: y, width: width, height: height)
            
            // Clear rectangle area
            context.setBlendMode(.clear)
            let rectPath = UIBezierPath(roundedRect: frameRect, cornerRadius: 15)
            rectPath.fill()
            
            // Draw golden border
            context.setBlendMode(.normal)
            UIColor(red: 0.831, green: 0.686, blue: 0.216, alpha: 1.0).setStroke()
            context.setLineWidth(3)
            rectPath.stroke()
            
            // Draw corner markers
            drawCornerMarkers(in: frameRect, context: context)
            
            // Draw guide text
            drawText("ضع الهوية في الإطار", at: CGPoint(x: rect.midX, y: frameRect.maxY + 30), in: context)
            
        case .general:
            return
        }
    }
    
    private func drawCornerMarkers(in rect: CGRect, context: CGContext) {
        let markerLength: CGFloat = 30
        let markerThickness: CGFloat = 4
        
        UIColor(red: 0.831, green: 0.686, blue: 0.216, alpha: 1.0).setStroke()
        context.setLineWidth(markerThickness)
        
        // Top-left
        context.move(to: CGPoint(x: rect.minX, y: rect.minY + markerLength))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX + markerLength, y: rect.minY))
        
        // Top-right
        context.move(to: CGPoint(x: rect.maxX - markerLength, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + markerLength))
        
        // Bottom-left
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY - markerLength))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minX + markerLength, y: rect.maxY))
        
        // Bottom-right
        context.move(to: CGPoint(x: rect.maxX - markerLength, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - markerLength))
        
        context.strokePath()
    }
    
    private func drawText(_ text: String, at point: CGPoint, in context: CGContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -2
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let size = attributedString.size()
        let rect = CGRect(
            x: point.x - size.width / 2,
            y: point.y,
            width: size.width,
            height: size.height
        )
        attributedString.draw(in: rect)
    }
}
