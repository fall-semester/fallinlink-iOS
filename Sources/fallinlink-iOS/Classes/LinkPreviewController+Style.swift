//
//  LinkViewController+Style.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/12.
//

import Foundation

public extension LinkViewController {
    class Style {
        var padding: CGFloat
        var lineWidth: CGFloat
        var containerPadding: CGFloat
        var decoSpacing: CGFloat
        
        public init(padding: CGFloat = 16,
             lineWidth: CGFloat = 2,
             containerPadding: CGFloat = 8,
             decoSpacing: CGFloat = 10) {
            self.padding = padding
            self.lineWidth = lineWidth
            self.containerPadding = containerPadding
            self.decoSpacing = decoSpacing
        }
    }
}
