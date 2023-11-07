//
//  LPMetadataProvider+.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/11.
//

import Foundation
import Combine
import LinkPresentation
import MobileCoreServices

extension LPMetadataProvider {
    func startFetchingMetadataPublisher(urlRequest: URLRequest) -> AnyPublisher<LinkMetadata, Error> {
        guard let url = urlRequest.url else {
            return Fail(error: LinkError.urlRequestError)
                .eraseToAnyPublisher()
        }
        return self.startFetchingMetadataPublisher(url: url)
    }
    
    func startFetchingMetadataPublisher(url: URL) -> AnyPublisher<LinkMetadata, Error> {
        Future<LinkMetadata, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(LinkError.objectError(object: self)))
                return
            }
            self.startFetchingMetadata(for: url) { metadata, error in
                if let error = error {
                    promise(.failure(LinkError.fetchingMetadataError(error: error)))
                    return
                }
                let title = metadata?.title
                let description = metadata?.value(forKey: "summary") as? String
                let iconProvider = metadata?.iconProvider
                let imageProvider = metadata?.imageProvider
            
                promise(.success(LinkMetadata(title: title,
                                              desc: description,
                                              iconProvider: iconProvider,
                                              imageProvider: imageProvider)))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func startFetchingMetadataWithImagePublisher(urlRequest: URLRequest) -> AnyPublisher<LinkMetadata, Error> {
        guard let url = urlRequest.url else {
            return Fail(error: LinkError.urlRequestError)
                .eraseToAnyPublisher()
        }
        return self.startFetchingMetadataWithImagePublisher(url: url)
    }
    
    func startFetchingMetadataWithImagePublisher(url: URL) -> AnyPublisher<LinkMetadata, Error> {
        self.startFetchingMetadataPublisher(url: url)
            .flatMap { linkMetadata in
                guard let iconProvider = linkMetadata.iconProvider else {
                    return Just<LinkMetadata>(linkMetadata)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return iconProvider.loadObjectPublisher(ofClass: UIImage.self)
                    .map{ $0?.compress(.medium) ?? $0 }
                    .map(linkMetadata.updateIcon(icon:))
                    .eraseToAnyPublisher()
            }
            .flatMap { linkMetadata in
                guard let imageProvider = linkMetadata.imageProvider else {
                    return Just<LinkMetadata>(linkMetadata)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return imageProvider.loadObjectPublisher(ofClass: UIImage.self)
                    .map{ $0?.compress(.medium) ?? $0 }
                    .map(linkMetadata.updateImage(image:))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
