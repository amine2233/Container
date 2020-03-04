//
//  Provider.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public protocol Provider {
    func register(_ services: inout Services) throws

    func willBoot(_ container: Container)

    func didBoot(_ container: Container)

    func willShutdown(_ container: Container)
}

extension Provider {
    func willBoot(_ container: Container) {}

    func didBoot(_ container: Container) {}

    func willShutdown(_ container: Container) {}
}
