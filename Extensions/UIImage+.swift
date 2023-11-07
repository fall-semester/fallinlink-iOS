//
//  UIImage+.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/12.
//

import UIKit

extension UIImage {
    enum CompressionQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
}

extension UIImage {
    var aspectBaseHeight: CGFloat {
        self.size.height / self.size.width
    }
    
    func compress(_ compressionQuality: CompressionQuality) -> UIImage? {
        guard let imageData = self.jpegData(compressionQuality: compressionQuality.rawValue) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

