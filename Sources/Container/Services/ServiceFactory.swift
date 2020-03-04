//
//  ServiceFactory.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

struct ServiceFactory<T> {
    let serviceType: T.Type

    var serviceSupports: [T.Type]

    let closure: (Container) throws -> T

    let isSingleton: Bool

    init(_ serviceType: T.Type, serviceSupports: [T.Type], isSingleton: Bool, _ closure: @escaping (Container) throws -> T) {
        self.serviceType = serviceType
        self.serviceSupports = serviceSupports
        self.isSingleton = isSingleton
        self.closure = closure
    }

    func makeService(for worker: Container) throws -> T {
        return try closure(worker)
    }
}
