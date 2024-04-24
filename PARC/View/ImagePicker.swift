//
//  ImagePicker.swift
//  PARC
//
//  Created by Ayman Ali on 09/11/2023.
//  Code adopted from - https://www.youtube.com/watch?v=a05eLxsbCCw&t=1147s

import SwiftUI

// Functionality that allows users to upload images from their phone gallery
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    private let image_controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        image_controller.delegate = context.coordinator
        return image_controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
