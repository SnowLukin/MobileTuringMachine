//
//  CustomDisclosureGroup.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 23.07.2022.
//

import SwiftUI

struct CustomDisclosureGroup<Content: View, Label: View>: View {
    @Binding var isExpended: Bool
    let content: Content
    let label: Label
    let selectionColor: Color
    
    init(isExpended: Binding<Bool>, selectionColor: Color = .clear,
         @ViewBuilder content: () -> Content,
         @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
        self._isExpended = isExpended
        self.selectionColor = selectionColor
    }
    
    var body: some View {
        VStack {
            HStack {
                label
                Spacer()
                Button {
                    withAnimation {
                        isExpended.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.bold())
                        .rotationEffect(
                            isExpended ? Angle.degrees(90) : Angle.degrees(0)
                        )
                }
            }
            .padding(.trailing, 10)
            .background(
                selectionColor.opacity(0.7).cornerRadius(10)
            )
            if isExpended {
                content
                    .transition(
                        .move(edge: .top)
                        .combined(
                            with: .asymmetric(
                                insertion: .opacity
                                    .animation(.easeIn(duration: 0.3)),
                                removal: .opacity
                                    .animation(.easeOut(duration: 0.1))
                            )
                        )
                    )
            }
        }
    }
}

/*
 MARK: Usage
    let item: <Your struct/class>
    var body: some View {
        CustomDisclosureGroup(isExpended: $isOpened, selectionColor: selection == item ? Color(UIColor.systemGray2) : .clear) {
            ForEach(children, id: \.self) { child in
                <Child cell>
            }
        } label: {
            <Item cell>
        }
    }
*/
