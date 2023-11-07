//
//  LinkMetadata.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/11.
//

import UIKit

struct LinkMetadata: CustomStringConvertible {
    let title: String?
    let desc: String?
    let iconProvider: NSItemProvider?
    let imageProvider: NSItemProvider?
    let icon: UIImage?
    let image: UIImage?
    
    var description: String {
        let desc = Mirror(reflecting: self).children.compactMap { (label: String?, value: Any) in
            return "\(label ?? "unknown")=\(value)"
        }.joined(separator: ",\n\t")
        return "LinkMetadata(\n\t\(desc)\n)"
    }
    
    init(title: String?,
         desc: String?,
         iconProvider: NSItemProvider?,
         imageProvider: NSItemProvider?,
         icon: UIImage? = nil,
         image: UIImage? = nil) {
        self.title = title
        self.desc = desc
        self.iconProvider = iconProvider
        self.imageProvider = imageProvider
        self.icon = icon
        self.image = image
    }
}

extension LinkMetadata {
    func updateIcon(icon: UIImage?) -> LinkMetadata {
        .init(title: title,
              desc: desc,
              iconProvider: iconProvider,
              imageProvider: imageProvider,
              icon: icon,
              image: image)
    }
    
    func updateImage(image: UIImage?) -> LinkMetadata {
        .init(title: title,
              desc: desc,
              iconProvider: iconProvider,
              imageProvider: imageProvider,
              icon: icon,
              image: image)
    }
}
