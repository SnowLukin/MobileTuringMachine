//
//  BindingPreviewWrapper.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 06.06.2022.
//

import SwiftUI

// MARK: Credits to AlanQuatermain – Jim Dovey for this piece of code.
// MARK: Git: https://github.com/AlanQuatermain
// MARK: Link to this code: https://github.com/AlanQuatermain/AQUI/blob/master/Sources/AQUI/StatefulPreviewWrapper.swift

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    public var body: some View {
        content($value)
    }

    public init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
