//
//  LinkError.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/11.
//

import Foundation

public enum LinkError<T: NSObject> {
    case urlRequestError
    case objectError(object: T?)
    case fetchingMetadataError(error: Error)
}

extension LinkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlRequestError:
            return NSLocalizedString("Invalid URLRequest - could not find url", comment: "could not find url")
        case let .objectError(object):
            return NSLocalizedString("could not find object(\(type(of: object)))",
                                     comment: "could not find object(\(type(of: object)))")
        case let .fetchingMetadataError(error):
            return NSLocalizedString("found error with fetching metadata\n\(error.localizedDescription)",
                                     comment: "found error with fetching metadata\n\(error.localizedDescription)")
        }
        
    }
}
