//
//  Extension + View.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.06.2022.
//

import SwiftUI

extension View {
    
    // MARK: Building modifier for custom popups
    func popupNavigationView<Content: View>(
        horizontalPadding: CGFloat = 40,
        show: Binding<Bool>,
        @ViewBuilder content: @escaping ()->Content
    ) -> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
                if show .wrappedValue {
                    // MARK: Reading container frame
                    GeometryReader { proxy in
                        
                        Color.primary
                            .opacity(0.15)
                            .ignoresSafeArea()
                        
                        let size = proxy.size
                        
                        NavigationView {
                            content()
                        }
                        .frame(width: size.width - horizontalPadding, height: size.height / 2, alignment: .center)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
    }
}

// MARK: Get size of the view
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
