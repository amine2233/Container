//
//  ServiceExtension.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

struct ServiceExtension<T> {
    public let closure: (inout T, Container) throws -> Void

    public init(closure: @escaping (inout T, Container) throws -> Void) {
        self.closure = closure
    }

    public func serviceExtend(_ instance: inout T, _ container: Container) throws {
        try closure(&instance, container)
    }
}
