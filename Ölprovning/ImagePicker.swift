//
//  ImagePicker.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-08-07.
//

import SwiftUI
import PhotosUI
import CoreData

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.managedObjectContext) var moc
    
    enum SourceType {
        case photoLibrary
        case camera
    }
    
    @Binding var selectedImages: [UIImage]
    let sourceType: SourceType
    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker: UIViewController
        
        switch sourceType {
        case .photoLibrary:
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 0
            
            let phpicker = PHPickerViewController(configuration: configuration)
            phpicker.delegate = context.coordinator
            picker = phpicker
            
        case .camera:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = context.coordinator
            picker = imagePicker
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        var uniqueImages: Set<UIImage> = []
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if parent.sourceType == .photoLibrary {
                let moc = parent.moc

                for result in results {
                    if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            if let image = image as? UIImage {
                                DispatchQueue.main.async {
                                    // Fix image orientation here
                                    let fixedImage = self.fixImageOrientation(image)

                                    // Check if the image is unique before adding it
                                    if !self.uniqueImages.contains(fixedImage) {
                                        self.uniqueImages.insert(fixedImage)
                                        self.parent.selectedImages.append(fixedImage)

                                        // Create a new Picture managed object and save the image data
                                        let picture = Picture(context: moc)
                                        if let imageData = fixedImage.jpegData(compressionQuality: 1.0) {
                                            picture.imageData = imageData
                                        }

                                        do {
                                            try moc.save()
                                        } catch {
                                            print("Error saving image: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        // Rest of your Coordinator code...
    

        
        
        func fixImageOrientation(_ image: UIImage) -> UIImage {
            if image.imageOrientation == .up {
                return image
            }
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return fixedImage ?? image
        }

        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if parent.sourceType == .camera {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImages.append(image)
                }
                picker.dismiss(animated: true)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            if parent.sourceType == .camera {
                picker.dismiss(animated: true)
            }
        }
    }
}
