//
//  AppModel.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 10/02/2022.
//

import AppKit
import Combine
import SwiftUI

class AppModel: ObservableObject {
    static let shared = AppModel()

    /// These Published vars are used to hold references to the AppKit NSWindows that the hosting window finder gets for us. We set them in here but they are cleared in a
    /// `NSWindow: NSWindowDelegate`. We have to do this rather than here using a delegate for the found NSWindow, because SwiftUI provides its own delegate for the windows
    /// it creates, and replacing those with own delegate object - even a pass-throug/forwarding one - for the window causes SwiftUI window management to fail (in particular the singleton
    /// handling provided by `handlesExternalEvents(preferring:allowing:)`)
    @Published internal var permanentNSWindow: NSWindow? = nil
    @Published internal var singletonNSWindow: NSWindow? = nil
    @Published internal var genericNSWindows: Set<NSWindow> = []

    @Published private(set) var keyWindow: NSWindow? = nil

    @Environment(\.openURL) private var openURL

    private var anyCancellable: Set<AnyCancellable> = []

    init() {
        /// Keep a record of what the keyWindow is because although we have references to our own `NSWindow`, those references do not appear to be getting  their keyWindow
        /// attributes updated in the SwiftUI lifecycle. i.e. `if singletonNSWindow.isKeyWindow == true then do something` does not work reliably. But if we set up
        /// our own listener for those changes that works.
        ///
        /// **NB**: Possible fragile solution for SwiftUI life-cycle
        /// This has to be `NSApplication.shared.publisher(for:  format ...)` and not:
        /// 1. `NSApp.publisher(for: \.keyWindow)` because that crashes as it's not initialised when this run.
        /// 2. `NSApplication.shared.keyWindow.publisher` because it just doesn't publish anything.
        ///
        /// Which, along with the fact that the app's window list publisher `NSApplication.shared.publisher(for: \.windows)` also does not publish updates  leads to the
        /// conclusing that previous AppKit window management tooling cannot be relied upon to be functional either now, or possibly in the future within the context of a SwiftUI app
        /// life-cycle. ** i.e. This code could be liable to breakage with a subsequent releases of SwiftUI [0]
        ///
        /// [0] Although hopefully by that time something less hacky will be available.
    

        NSApplication.shared.publisher(for: \.keyWindow)
            .sink { keyWindow in
                self.keyWindow = keyWindow
            }
            .store(in: &anyCancellable)
    }

    /// func openPermanentWindow() {
    /// /// No need for this  because SwiftUI create the window by default at startup and the app has no way to close that one so it should never need reopening
    /// }

    func openOrRaiseSingletonWindow() {
        /// `handleExternalEvents(preferring: allowing:)` is used to ensure singleton'ness as that will work both for us opening here and for anyone
        /// clicking on a link in an external application
        openWindowViaUrl(AppConfig.SingletonWinConfig)
    }

    func openGenericWindow() {
        guard let title: String = AppConfig.TestWindowNamesForTabsAndGenericWindows.randomElement() else {
            print("Error, unable to create generic window because couldn't get a suitable random title for it")
            return
        }

        openWindowViaUrl(AppConfig.GenericWinConfig, querries: [URLQueryItem(name: AppConfig.UrlTitleQuerryItemKey, value: title)])
    }

    /// 1) We have to maintain these window references ourselves because AppKit's `NSApplication.windows.publisher` does not  work  in the SwiftUI app life-cycle.
    /// 2) We have to use a `HostingWindowFinder`probe view after handling the URL routing to get the `NSWindow` references because opening via openURI is currently
    /// the only  idiomatic SwiftUI approach to opening a new window, and opening a URL doesn't provide the window reference when new window the is forked off.

    func setSingletonWindow(_ window: NSWindow?) {
        if let window = window {
            guard singletonNSWindow == nil else {
                print("Bailing out")
                return
            }
            print("Registering a new singleton")
            singletonNSWindow = window
        }
    }

    func addGenericWindow(_ window: NSWindow?) {
        if let window = window {
            print("Adding generic window")
            genericNSWindows.insert(window)
        }
    }

    func setPermanentWindow(_ window: NSWindow?) {
        if let window = window {
            permanentNSWindow = window
        }
    }

    static func titleFromUrl(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryItems = components?.queryItems {
//            print("qu = \(queryItems)")
            let title: String? = queryItems.first(where: { $0.name == AppConfig.UrlTitleQuerryItemKey })?.value
            if let title = title {
                return title
            } else {
                print("Error, no title query item found in url = \(url)")
                return nil
            }
        } else {
            print("Error, no query items decoded from url = \(url)")
            return nil
        }
    }

    /// NB: This approach will only work if the app has registered a URL Type handling scheme as part of its target config under Project -> Target swiftuiWindowFun -> Info -> URL Types )
    private func openWindowViaUrl(_ winConfig: WindowConfig, querries: Array<URLQueryItem> = []) {
        var components = URLComponents()
        components.scheme = AppConfig.UrlSchemeName
        components.host = winConfig.uriHost
        components.queryItems = querries

        guard let url = components.url else { return }
        openURL(url)
    }
}
