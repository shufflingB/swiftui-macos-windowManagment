//
//  HostingWindowFinder.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 09/02/2022.

import SwiftUI

#if canImport(AppKit)
    /// Same approach can also be used for UIKit, see LostMoa's blog post https://lostmoa.com/blog/ReadingTheCurrentWindowInANewSwiftUILifecycleApp/
    /// on which the approach here is closely based.

    struct HostingWindowFinder: NSViewRepresentable {
        let callback: (NSWindow?) -> Void

        func makeNSView(context: Self.Context) -> NSView {
            let view = NSView()

            DispatchQueue.main.async { [weak view] in

                self.callback(view?.window)
            }
            return view
        }

        func updateNSView(_ nsView: NSView, context: Context) {}
    }
#else
    #error("Unsupported platform")
#endif
