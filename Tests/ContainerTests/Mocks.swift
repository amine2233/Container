//
//  File 2.swift
//  
//
//  Created by Amine Bensalah on 04/03/2020.
//

import Foundation

protocol MockDataBaseProtocol {
    var name: String { get }
}

struct MockDataBase: MockDataBaseProtocol {
    let name: String
}

struct MockDataBaseLocal: MockDataBaseProtocol {
    let name: String

    init(name: String) {
        self.name = name
    }
}
