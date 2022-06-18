//
//  RootPresentationEnvironmentKey.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 18.06.2022.
//

import SwiftUI

struct RootPresentationKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var rootPresentation: Binding<Bool> {
        get {
            self[RootPresentationKey.self]
        }
        set {
            self[RootPresentationKey.self] = newValue
        }
    }
}
