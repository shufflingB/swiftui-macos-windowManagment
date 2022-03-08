//
//  HostingWindowFinder.swift
//  HostingWindowFinder
///
/// This code is is from Lost Moa's blog post https://lostmoa.com/blog/ReadingTheCurrentWindowInANewSwiftUILifecycleApp/
///

import SwiftUI

#if canImport(UIKit)
    typealias Window = UIWindow
#elseif canImport(AppKit)
    typealias Window = NSWindow
#else
    #error("Unsupported platform")
#endif

/// Same approach should work for UIKit as well, but is unused and untested here.
#if canImport(UIKit)
    struct HostingWindowFinder: UIViewRepresentable {
        var callback: (Window?) -> Void

        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async { [weak view] in
                self.callback(view?.window)
            }
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }

#elseif canImport(AppKit)
    struct HostingWindowFinder: NSViewRepresentable {
        let callback: (Window?) -> Void

        
        
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
