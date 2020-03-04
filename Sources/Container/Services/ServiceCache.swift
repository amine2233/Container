//
//  ServiceCache.swift
//  ApplicationDelegate
//
//  Created by Amine Bensalah on 15/11/2019.
//

import Foundation

internal struct ServiceCache {

    private var storage: [ServiceId: Any]

    init() {
        self.storage = [:]
    }

    func get<S>(service: S.Type) -> S? {
        let id = ServiceId(S.self)
        guard let service = self.storage[id] as? S else { return nil }
        return service
    }

    mutating func set<S>(service: S) {
        let id = ServiceId(S.self)
        self.storage[id] = service
    }

    mutating func clear() {
        self.storage = [:]
    }
}
