//
//  Container.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public enum ContainerError: Error {
    case unregistred
    case ambiguity
    case missing
    case tooMany
    case typeRequirement
    case notFound
}

public final class Container {

    /// Service `Environment` (e.g., production, dev). Use this to dynamically swap services based on environment.
    public private(set) var environment: Environement

    /// Service `Config`. Used to disambiguate and/or require concrete services for a given interface.
    public var config: Config

    /// Available services. This struct contains all of this `Container`'s available service implementations.
    public var services: Services

    /// This `Container`'s cached service instances. This is not shared when creating sub-containers.
    private var cache: ServiceCache

    private var didShutdown: Bool

    /// The array of `Provider`
    public var providers: [Provider] {
        return self.services.providers
    }

    public init(environment: Environement, config: Config, services: Services) {
        self.environment = environment
        self.config = config
        self.services = services
        self.cache = .init()
        self.didShutdown = false
    }

    /// Make a service
    /// - parameters:
    ///     - service: the type of of service `S.Type`
    /// - returns: The service `S`
    public func make<S>(_ service: S.Type = S.self) throws -> S {
        assert(!self.didShutdown, "Container.shutdown() has been called, this Container is no longer valid.")

        // check if cached
        if let cached = self.cache.get(service: S.self) {
            return cached
        }

        // get on config requirement or preference or create service lookup identifier
        let id = unsafeService(S.self)

        // fetch service factory if one exists
        guard let factory = self.services.factories[id] as? ServiceFactory<S> else {
            fatalError("No services available for \(S.self)")
        }

        // create the service
        var instance = try factory.makeService(for: self)

        // check for any extensions
        if let extensions = self.services.extensions[id] as? [ServiceExtension<S>], !extensions.isEmpty {
            // loop over extensions, modifying instace
            try extensions.forEach { try $0.serviceExtend(&instance, self) }
        }

        // cache if singleton
        if factory.isSingleton {
            self.cache.set(service: instance)
        }

        // return created and extended instance
        return instance
    }

    internal func unsafeService<S>(_ interface: S.Type) -> ServiceId {
        return self.config.require(interface) ?? self.config.preference(interface) ?? ServiceId(S.self)
    }

    private func willBoot() -> Container {
        _ = self.providers.map { $0.willBoot(self) }
        return self
    }

    private func didBoot() -> Container {
        _ = self.providers.map { $0.didBoot(self) }
        return self
    }

    /// Shutdonw the container, this will be clear all the cache `Singleton`
    public func shutdown() {
        self.cache.clear()
        self.didShutdown = true
    }

    /// Update the container Environement
    /// - parameters:
    ///     - environment: the new `Environment`
    /// - returns: The `Container` it self
    @discardableResult
    public func switchEnvironement(_ environment: Environement) -> Container {
        shutdown()
        self.environment = environment
        self.didShutdown = false
        return willBoot().didBoot()
    }

    deinit {
        assert(self.didShutdown, "Container.shutdown() was not called before Container deinitialized")
    }
}
