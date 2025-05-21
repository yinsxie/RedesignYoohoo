//
//  ImageSaver.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 15/05/25.
//
import UIKit

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: (() -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            errorHandler?()
        } else {
            successHandler?()
        }
    }
}
