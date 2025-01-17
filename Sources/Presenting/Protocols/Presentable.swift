//
//  Presentable.swift
//
//  Created by James Sedlacek on 12/14/23.
//

import SwiftUI

public protocol Presentable: Identifiable, Hashable, Equatable {

    associatedtype Body: View

    var id: Self { get }

    @ViewBuilder @MainActor var body: Body { get }
}

extension Presentable {
    public var id: Self { self }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
