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
        /// Allow or deny closing and the removal redundant references to windows. NB: The information removal would more correctly use `windowWillClos`, but because
        /// SwiftUI already supplies its own delegate  method  we cannot override it (if we attempt to it just gets silently ignored)

        switch sender.windowNumber {
        case appModel.permanentNSWindow?.windowNumber:
            print("Denying enquiry to close \(sender.title), \(sender.windowNumber)")
            return false
        case appModel.singletonNSWindow?.windowNumber:
            print("Allowing closing of window \(sender.title), \(sender.windowNumber)")
            appModel.singletonNSWindow = nil
            return true
        case _ where appModel.genericNSWindows.contains(sender):
            print("Closing window \(sender.title), \(sender.windowNumber)")

            appModel.genericNSWindows.remove(sender)//     filter({ $0.windowNumber != closingWindowNumber })
            return true

        default:
            print("Defaulting to allow closing of unknown window \(sender.title), \(sender.windowNumber)")
            return true
        }
    }
}
