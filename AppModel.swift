//
//  AppModel.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 10/02/2022.
//

import SwiftUI

class AppModel: NSObject, ObservableObject {
    @Published var windows = Set<NSWindow>()

    @Environment(\.openURL) private var openURL

    enum GroupId: String {
        case win2
        case win3
    }

    func openWindowViaUrl(_ identifier: GroupId) {
        guard let url = URL(string: "swiftuiWindowFun://\(identifier.rawValue)") else { return }

        openURL(url)
//        NSWorkspace.shared.open(url)
    }

    func addWindow(window: NSWindow) {
        window.delegate = self
        windows.insert(window)
    }
}

extension AppModel: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            windows = windows.filter { $0.windowNumber != window.windowNumber }
        }
    }
}

