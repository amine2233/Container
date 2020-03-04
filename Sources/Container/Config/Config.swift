//
//  Container.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

public struct Config: CustomStringConvertible {
    /// Stored service preferences. [Interface: Service]
    fileprivate var preferences: [ServiceId: ServiceId]

    /// Stored service requirements. [Interface: Service]
    fileprivate var requirements: [ServiceId: ServiceId]

    /// See `CustomStringConvertible`
    public var description: String {
        var desc: [String] = []

        func list(_ name: String, _ list: [ServiceId: ServiceId]) {
            desc.append("\(name):")
            if list.isEmpty {
                desc.append("- none")
            } else {
                for (key, val) in list {
                    desc.append("- \(key): \(val)")
                }
            }
        }
        list("Preferences", preferences)
        list("Requirements", requirements)

        return desc.joined(separator: "\n")
    }

    /// Creates an empty `Config`.
    public init() {
        self.preferences = [:]
        self.requirements = [:]
    }

    /// Use this method to disambiguate multiple available service implementations for a given interface.
    ///
    ///     config.prefer(RedisCache.self, for: Cache.self)
    ///
    /// - parameters:
    ///     - type: Concrete service type to prefer. This should not be a protocol.
    ///     - interface: The interface to prefer this concrete service for. This must be a protocol that the service conforms to.
    public mutating func prefer(_ type: Any.Type, for interface: Any.Type) {
        preferences[.init(interface)] = .init(type)
    }

    ///  Use this method to require a given implementation for an interface.
    ///
    ///     config.require(ProductionLogger.self, for: Logger.self)
    ///
    /// - parameters:
    ///     - type: Concrete service type to require. This should not be a protocol.
    ///     - interface: The interface to require this concrete service for. This must be a protocol that the service conforms to.
    public mutating func require(_ type: Any.Type, for interface: Any.Type ) {
        requirements[.init(interface)] = .init(type)
    }

    internal func preference(_ type: Any.Type) -> ServiceId? {
        guard let pref = preferences[.init(type)] else { return nil }
        return pref
    }

    internal func require(_ type: Any.Type) -> ServiceId? {
        guard let pref = requirements[.init(type)] else { return nil }
        return pref
    }
}
