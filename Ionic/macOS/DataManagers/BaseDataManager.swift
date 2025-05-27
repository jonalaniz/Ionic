//
//  BaseDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/26/25.
//

import Foundation

class BaseDataManager: NSObject {
    weak var errorHandler: ErrorHandling?
    
    let service = IONOSService.shared
    let source: ErrorSource
    
    init(source: ErrorSource) {
        self.source = source
    }
    
    func handleError(_ error: Error) {
        guard let apiError = error as? APIManagerError else {
            errorHandler?.handle(
                error: APIManagerError.somethingWentWrong(error: error),
                from: source
            )
            return
        }
                
        errorHandler?.handle(error: apiError, from: .zoneDataManager)
    }
}
