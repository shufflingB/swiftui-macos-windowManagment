//
//  DelegateForwarder.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 17/03/2022.
//

import SwiftUI
class UnusedDelegateForwarer<T: NSObjectProtocol>: NSObject {
    ///
    ///  **UNUSED CODE HERE FOR  CURIOSITY'S SAKE ONLY**
    /// This is  based on Matt Curtiss' Gist here https://gist.github.com/matt-curtis/65eb4bd7e98e6ace2d220c3067df7fc7
    /// The class was an attempt at  inserting delegate methods as  fallbacks to the ones that SwiftUI configuring for the NSWindow's that it creates.
    ///
    /// Unfortunately it does not work; SwiftUI seems to be reliant on side-effects associated with using its own `NSWindowDelegate` instances (rather than just the delegates methods) [0].
    ///  However,  I've kept it here as  it's an interesting example of how it could have been done,  probing what delegates SwiftUI is supplying and when they are being triggered.
    ///
    /// [0] What does work though is to extend `NSWindow` itself.

    weak var myDelegate: T?
    weak var swiftUIDelegate: T?

    var asConforming: T {
        return unsafeBitCast(self, to: T.self)
    }

    init(myDelegate: T? = nil, swiftUIDelegate: T? = nil) {
        self.myDelegate = myDelegate
        self.swiftUIDelegate = swiftUIDelegate
        print("myDelegate = \(String(describing: myDelegate))")
        print("otherDelegate = \(String(describing: swiftUIDelegate))")
    }

    override func responds(to sel: Selector!) -> Bool {
        if let swiftUIDelegate = swiftUIDelegate, swiftUIDelegate.responds(to: sel) { // Prefer safe SwiftUI if more than one choice
            print("Default swiftUIDelegate responds to \(sel.description)")
            return true
        } else if let myDelegate = myDelegate, myDelegate.responds(to: sel) {
            print("myDelegate responds to \(sel.description)")
            return true
        } else {
            print("- neither delegate responds to \(sel.description)")
            return false
        }
    }

    override func forwardingTarget(for sel: Selector!) -> Any? {
        if swiftUIDelegate?.responds(to: sel) == true { // Prefer safe SwiftUI if more than one choice
            print("Default swiftUIDelegate is forwardingTarget for sel = \(sel.description)")
            return swiftUIDelegate
        } else {
            print("myDelegate is forwardingTarget for sel = \(sel.description)")
            return myDelegate
        }
    }
}
