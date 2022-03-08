//
//  AppModel+NSDelegate.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 24/02/2022.
//
import AppKit

extension AppModel: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let windowClosing = notification.object as? NSWindow {
            switch windowClosing.windowNumber {
            case permanentNSWindow?.windowNumber:
                print("Closing window \(windowClosing.title), \(windowClosing.windowNumber)")
                permanentNSWindow = nil
            case singletonNSWindow?.windowNumber:
                print("Closing window \(windowClosing.title), \(windowClosing.windowNumber)")

                singletonNSWindow = nil
            case let closingWindowNumber where genericNSWindows.contains(where: { $0.windowNumber == closingWindowNumber }):
                print("Closing window \(windowClosing.title), \(windowClosing.windowNumber)")

                genericNSWindows = genericNSWindows.filter({ $0.windowNumber != closingWindowNumber })

            default:

                print("Unknown window \(windowClosing.title), \(windowClosing.windowNumber)")
            }
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if sender.windowNumber == permanentNSWindow?.windowNumber {
            return false
        } else {
            return true
        }
    }
}
