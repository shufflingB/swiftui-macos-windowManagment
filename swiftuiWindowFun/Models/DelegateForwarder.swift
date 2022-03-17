//
//  DelegateForwarder.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 17/03/2022.
//

import SwiftUI
class DelegateForwarder<T: NSObjectProtocol>: NSObject {
    ///
    /// This is  based on Matt Curtiss' gist here https://gist.github.com/matt-curtis/65eb4bd7e98e6ace2d220c3067df7fc7
    /// The class enable inserting our own delegate methods as fallbacks to the ones that SwiftUI configures for NSWindow's that it creates.
    ///
    /// Unfortunately SwiftUI seems to be reliant on side-effects associated with its own `NSWindowDelegate` instance (rather than just the delegates methods). So this approach
    /// DOES NOT WORK  as method for supplying `NSWindow` delegate functionally in SwiftUI.  However,  it's useful and interesting  because of the way it probes what delegates
    /// SwiftUI is supplying and when they are being triggered.
    ///

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
