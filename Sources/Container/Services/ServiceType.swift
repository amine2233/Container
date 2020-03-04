//
//  ServiceType.swift
//
//  Created by Amine Bensalah on 15/11/2019.
//

/// A `Service` type that is capable of statically conforming to `ServiceFactory`.
///
/// `ServiceTypes` can be registered using just their type name.
///
///     services.register(RedisCache.self)
///
/// This protocol implies `Service` conformance on the created service.
public protocol ServiceType {
    /// An array of protocols (or types) that this service conforms to.
    ///
    /// For example, when `container.make(X.self)` is called, all services that support `X` will be considered.
    ///
    /// See `ServiceFactory` for more information.
    static var serviceSupports: [Any.Type] { get }

    /// Creates a new instance of the service for the supplied `Container`.
    ///
    /// See `ServiceFactory` for more information.
    static func makeService(for container: Container) throws -> Self
}

/// MARK: Default Implementations

extension ServiceType {
    /// See `ServiceType`
    public static var serviceSupports: [Any.Type] {
        return []
    }
}

extension Services {
    public mutating func singleton<S: ServiceType>(_ interface: S.Type) {
        let id = ServiceId(S.self)
        let factory = ServiceFactory(S.self, serviceSupports: [S.self], isSingleton: true) { container in
            return try S.makeService(for: container)
        }
        self.factories[id] = factory
    }

    public mutating func register<S: ServiceType>(_ interface: S.Type) {
        let id = ServiceId(S.self)
        let factory = ServiceFactory(S.self, serviceSupports: [S.self], isSingleton: false) { container in
            return try S.makeService(for: container)
        }
        self.factories[id] = factory
    }
}
