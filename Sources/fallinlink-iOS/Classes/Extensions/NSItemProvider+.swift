//
//  NSItemProvider+.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/12.
//

import Foundation
import Combine

extension NSItemProvider {
    func loadObjectPublisher<T: NSItemProviderReading>(ofClass: T.Type) -> AnyPublisher<T?, Error> {
        return Future<T?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(LinkError.objectError(object: self)))
                return
            }
            self.loadObject(ofClass: ofClass) { object, error in
                promise(.success(object as? T))
            }
        }
        .eraseToAnyPublisher()
    }
}
