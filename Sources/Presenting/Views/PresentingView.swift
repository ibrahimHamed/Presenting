//
//  PresentingView.swift
//
//  Created by James Sedlacek on 12/18/23.
//

import SwiftUI

public struct PresentingView<RootView: View, Routes: Presentable>: View {
    @StateObject private var presenter: Presenter<Routes> = .init()
    private let rootView: (Presenter<Routes>) -> RootView

    public init(_ routeType: Routes.Type, @ViewBuilder rootView: @escaping (Presenter<Routes>) -> RootView) {
        self.rootView = rootView
    }

    public var body: some View {
        rootView(presenter)
            .sheet(item: $presenter.sheet) {
                presenter.onDismiss?()
            } content: { route in
                route.body.environmentObject(presenter)
            }
            .iflet(presenter.alert) { rootView, alert  in
                rootView.alert(isPresented: presenter.isAlertPresented) {
                    alert
                }
            }
            .iflet(presenter.toastConfig) { rootView, toastConfig in
                rootView.toast(config: toastConfig,
                               onCompletion: presenter.dismissToast)
            }
            .iflet(presenter.urlConfig) { rootView, _ in
                rootView.openURL(config: $presenter.urlConfig)
            }
            .iflet(presenter.confirmationDialog) { rootView, confirmationDialog in
                rootView.confirmationDialog(config: confirmationDialog,
                                            isPresented: presenter.isConfirmationDialogPresented)
            }
#if !os(macOS)
            .fullScreenCover(item: $presenter.fullScreenCover, onDismiss: {
                presenter.onDismiss?()
            }, content: { route in
                route.body.environmentObject(presenter)
            })
#endif
    }
}

