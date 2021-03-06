//
//  Extension + View.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 03.06.2022.
//

import SwiftUI

extension View {
    
    // MARK: - Building modifier for custom popups
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
    
    
    // MARK: - Get size of the view
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    
    // MARK: - Alert with textfield
    func alertTextField(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel) { _ in
            secondaryAction()
        })
        
        alert.addAction(.init(title: primaryTitle, style: .default) { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        })
        
        // Presenting alert
        getRootController().present(alert, animated: true)
    }
    
    // MARK: - Root View Controller
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    // MARK: - Sheet
    func sheetWithDetents<Content>(
            isPresented: Binding<Bool>,
            detents: [UISheetPresentationController.Detent],
            onDismiss: (() -> Void)?,
            content: @escaping () -> Content) -> some View where Content : View {
                modifier(
                    sheetWithDetentsViewModifier(
                        isPresented: isPresented,
                        detents: detents,
                        onDismiss: onDismiss,
                        content: content)
                )
            }
    
    // MARK: - Alert with textfield
    func alertWithTextField(title: String? = nil,
                            message: String? = nil,
                            hintText: String? = nil,
                            primaryTitle: String? = nil,
                            secondaryTitle: String? = nil,
                            primaryAction: @escaping (String) -> (),
                            secondaryAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: primaryTitle, style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }
        saveAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: secondaryTitle, style: .cancel) { _ in
            secondaryAction()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        alert.addTextField { textField in
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                    {_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                
                saveAction.isEnabled = textIsNotEmpty
            })
            
            textField.placeholder = hintText
        }
        
        // Presenting alert
        rootController().present(alert, animated: true)
    }
    
    // MARK: Root View Controller
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        return root
    }
    
    func splitViewPreferredDisplayMode(_ mode: UISplitViewController.DisplayMode) -> some View {
        self.environment(\.splitViewPreferredDisplayMode, mode)
    }
}
