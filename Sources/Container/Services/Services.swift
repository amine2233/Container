//
//  Services.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public protocol ServiceIdentifier {
    static var serviceIdentifier: String { get }
}

extension ServiceIdentifier {
    public static var serviceIdentifier: String {
        return String(describing: self)
    }
}

struct ServiceId: Hashable, Equatable, CustomStringConvertible, ServiceIdentifier {

    static func == (lhs: ServiceId, rhs: ServiceId) -> Bool {
        return lhs.type == rhs.type
    }

    /// See `Hashable`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    var description: String {
        return "\(type)"
    }

    let type: Any.Type

    init(_ type: Any.Type) {
        self.type = type
    }
}

public struct Services: CustomStringConvertible {

    var factories: [ServiceId: Any]

    var extensions: [ServiceId: [Any]]

    var providers: [Provider]

    public init() {
        self.factories = [:]
        self.providers = []
        self.extensions = [:]
    }

    public mutating func instance<S>(_ interface: S.Type, _ instance: S) {
        let id = ServiceId(S.self)
        let factory = ServiceFactory(S.self, serviceSupports: [S.self], isSingleton: false) { _ in
            return instance
        }
        self.factories[id] = factory
    }

    public mutating func instance<S>(_ instance: S) {
        return self.instance(S.self, instance)
    }

    public mutating func singleton<S>(_ interface: S.Type, _ factory: @escaping (Container) throws -> (S)) {
        let id = ServiceId(S.self)
        let factory = ServiceFactory(S.self, serviceSupports: [S.self], isSingleton: true) { container in
            return try factory(container)
        }
        self.factories[id] = factory
    }

    public mutating func register<S>(_ interface: S.Type, _ factory: @escaping (Container) throws -> (S)) {
        let id = ServiceId(S.self)
        let factory = ServiceFactory(S.self, serviceSupports: [S.self], isSingleton: false) { container in
            return try factory(container)
        }
        self.factories[id] = factory
    }

    // MARK: Extend

    public mutating func extend<S>(_ interface: S.Type, _ closure: @escaping (inout S, Container) throws -> Void) {
        let id = ServiceId(S.self)
        let ext = ServiceExtension<S>(closure: closure)
        self.extensions[id, default: []].append(ext)
    }

    public var description: String {
        var desc: [String] = []

        desc.append("Services:")
        if factories.isEmpty {
            desc.append("<none>")
        } else {
            for (id, _) in factories {
                desc.append("- \(id.type)")
            }
        }

        desc.append("Extensions:")
        if extensions.isEmpty {
            desc.append("<none>")
        } else {
            for (id, array) in extensions {
                desc.append("- \(id.type)")
                for elm in array {
                    desc.append("- - \(elm.self)")
                }
            }
        }

        desc.append("Providers:")
        if providers.isEmpty {
            desc.append("- none")
        } else {
            for provider in providers {
                desc.append("- \(type(of: provider))")
            }
        }

        return desc.joined(separator: "\n")
    }
}
