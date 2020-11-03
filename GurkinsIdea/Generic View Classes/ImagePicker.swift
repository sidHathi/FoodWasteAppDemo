//
//  ImagePickwer.swift
//  GurkinsIdea
//
//  Created by Siddharth Hathi on 1/26/20.
//  Copyright © 2020 Holopacer. All rights reserved.
//

import SwiftUI

/**
Description:
Type: UIView SwiftUI Representable Class
Functionality: This class constructs the UIImagePicker that the user uses to select profile images in a SwiftUI context
*/
struct ImagePicker: UIViewControllerRepresentable {
    
    // Public presentationmode that contains presentation context
    @Environment(\.presentationMode) var presentationMode
    
    // Reference to image being changed within parent
    @Binding var image: UIImage?

    // Functiont that builds the UIImagePickerController and sets its delegate
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    // stub
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    // Function that sets the ImagePicker's coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class that handles selection of images
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
