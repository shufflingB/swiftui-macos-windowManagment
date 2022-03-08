//
//  AppModel.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 10/02/2022.
//

import AppKit
import Combine
import SwiftUI

class AppModel: NSObject, ObservableObject {
    /// Bring NSObject into the eqn bc we have to assign ourselves as NSWindow.delegate to be able to remove windows from our records when they are closed.

    static let shared = AppModel()

    /// This needs to be set as per the Project's Target -> Info -> Url Type configurarion
    static let urlSchemeName = "swiftuiWindowFun"
    static let urlTitleQuerryItemKey = "title"

    /// Configure window title's (or placeholder) and hostname part of the uri that is to get used to route to that window
    static let permanentWinConfig = WindowConfig(title: "Permanent main window", uriHost: "main")
    static let singletonWinConfig = WindowConfig(title: "Singleton window", uriHost: "singleton")
    static let genericWinConfig = WindowConfig(title: "Placeholder generic window title", uriHost: "generic")

    /// Set up a list of names to give to generic windows and tabs to make them a bit easier to distinguis and show how the URL routing and decoding works
    static let testWindowNamesForTabsAndGenericWindows: Array<String> = ["Kirk", "Checkov", "McCoy", "Scotty", "Spock", "Sulu", "Uhura", "Pike", "Rand", "Trelane", "Surak", "Kelinda"]

    @Published internal var permanentNSWindow: NSWindow? = nil
    @Published internal var singletonNSWindow: NSWindow? = nil
    @Published var genericNSWindows: Array<NSWindow> = []
    @Published private(set) var keyWindow: NSWindow? = nil

    @Environment(\.openURL) private var openURL

    private var anyCancellable: Set<AnyCancellable> = []

    override init() {
        super.init()

        // We need to keep a record of what the keyWindow is because although we have references to our own
        // NSWindow, those references do not get their keyWindow attributes updated in the SwiftUI lifecycle.
        // i.e. "if singletonNSWindow.isKeyWindow == true then do something" does not reliably stay up to date.
        // Whereas "if singletonNSWindow == appModel.keyWindow ..." does work reliably.
        //
        /// **NB**: This has to be NSApplication.shared.publisher(for:  format ...) because  NSApp.publisher(for: \.keyWindow)
        /// crashes as it's not initialised and NSApplication.shared.keyWindow.publisher just doesn't publish anything.
        /// This, along with the fact that NSApplication.shared.publisher(for: \.windows) does not publish anything either
        /// leads to a strong suspicion that when the SwiftUI app lifecycle is being used the normal underlying AppKit lifecycle is
        /// is different.
        /// **==>> This code could be liable to breakage with a subsequent releases of SwiftUI. Although hopefully by that time
        /// something less hacky will be available ... one to watch out for!
        ///

        NSApplication.shared.publisher(for: \.keyWindow)
            .sink { keyWindow in
                self.keyWindow = keyWindow
            }
            .store(in: &anyCancellable)
    }

    /// If wondering, no need for an openPermanentWindow because SwiftUI does that for us by default and the app has no way to close that one
    func openOrRaiseSingletonWindow() {
        guard singletonNSWindow == nil else {
            singletonNSWindow!.makeKeyAndOrderFront(nil)
            return
        }
        openWindowViaUrl(Self.singletonWinConfig)
    }

    func openGenericWindow() {
        guard let title: String = Self.testWindowNamesForTabsAndGenericWindows.randomElement() else {
            print("Error, unable to create generic window because couldn't get a suitable random title for it")
            return
        }

        openWindowViaUrl(Self.genericWinConfig, querries: [URLQueryItem(name: Self.urlTitleQuerryItemKey, value: title)])
    }

    /// Aside: It's a bit annoying that:
    /// 1. We have to maintain these window references ourselves and can't rely on AppKit's normal toolbox to account for the for us - specifically AppKit's  NSApplication.windows.publisher does not seem to work  in the SwiftUI life-cycle.
    /// 2. We have to use a`HostingWindowFinder`probe view post handling the URL to get hold of the new window references, because opening via openURI is the only "pure" SwiftUI way to open a new windows and it does not give us an reference to the new window when we trigger the fork.

    func setSingletonWindow(_ window: NSWindow?) {
        if let window = window {
            guard singletonNSWindow == nil else {
                print("Bailing out")
                return
            }
            print("Registering a new singleton")
            singletonNSWindow = window
            window.delegate = self // <- Have to assign the NSWindow delegate so you get an opportunity to remove from the model when the window closes
        }
    }

    func addGenericWindow(_ window: NSWindow?) {
        if let window = window {
            print("Adding window")
            genericNSWindows.append(window)
            window.delegate = self
        }
    }

    func setPermanentWindow(_ window: NSWindow?) {
        if let window = window {
            permanentNSWindow = window
            window.delegate = self
        }
    }

    static func titleFromUrl(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryItems = components?.queryItems {
//            print("qu = \(queryItems)")
            let title: String? = queryItems.first(where: { $0.name == Self.urlTitleQuerryItemKey })?.value
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
        components.scheme = Self.urlSchemeName
        components.host = winConfig.uriHost
        components.queryItems = querries

        guard let url = components.url else { return }
        openURL(url)
    }
}
