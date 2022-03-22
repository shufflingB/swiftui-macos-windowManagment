//
//  AppModel+NSDelegate.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 24/02/2022.
//
import SwiftUI

extension NSWindow: NSWindowDelegate {
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        let appModel = AppModel.shared
        /// This delegate is used to:
        /// 1)  Allow or deny closing of the window when the close window button is pressed on the window.
        /// 2)  Remove redundant references to windows that are about to be closed [0].
        ///
        /// [0]  NB: Strictly speaking cleaning these reference up should be more correctly done in `windowWillClose`, but because SwiftUI  already supplies its own delegate
        /// method for that  we cannot override it for our own purposes (if we attempt to it just gets silently ignored). **The downside of this approach is that if `close` is called, rather
        /// than `performClose`,  then this code is not called and the window references will be incorrect.**

        switch sender.windowNumber {
        case appModel.permanentNSWindow?.windowNumber:
            print("Denying enquiry to close \(sender.title), \(sender.windowNumber)")
            return false /// It's a permanent window, so any request to close it should be refused.
        case appModel.singletonNSWindow?.windowNumber:
            print("Allowing closing of window \(sender.title), \(sender.windowNumber)")
            appModel.singletonNSWindow = nil
            return true
        case _ where appModel.genericNSWindows.contains(sender):
            print("Closing window \(sender.title), \(sender.windowNumber)")

            appModel.genericNSWindows.remove(sender)
            return true

        default:
            print("Defaulting to allow closing of unknown window \(sender.title), \(sender.windowNumber)")
            return true
        }
    }
}
