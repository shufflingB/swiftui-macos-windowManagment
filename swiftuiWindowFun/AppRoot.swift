//
//  swiftuiWindowFunApp.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 09/02/2022.
//

import SwiftUI

@main
struct AppRoot: App {
    @StateObject var appModel = AppModel.shared

    /// App maintains three window groups
    /// - First is a main, permanently open window. This cannot be closed and there is no way in the app to create a new one.
    /// - Second is a singleton window. This can be closed but only a single instance of it may exists at one time
    /// - Third is a generic window, many of which can be spawned and closed as needed.

    var body: some Scene {
        /// Default, permanent, non-closable, no way to create new one.  in the app "main: window. As there is no way to
        /// create new instance there is no need for the handlesExternalEvents modifier to be used to enforce it's singleton'ness
        /// (as there is with the other window in the the app)
        WindowGroup(AppConfig.PermanentWinConfig.title) {
            PermanentView()
                .environmentObject(appModel)
                .background { HostingWindowFinder(callback: appModel.setPermanentWindow) }
        }
        .handlesExternalEvents(matching: [AppConfig.PermanentWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }

        /// Singleton window - handled by `handlesExternalEvents(preferring: allowing:)` in the SingletonView itself
        WindowGroup(AppConfig.SingletonWinConfig.title) {
            SingletonView()
                .environmentObject(appModel)
                .background { HostingWindowFinder(callback: appModel.setSingletonWindow) }
        }
        .handlesExternalEvents(matching: [AppConfig.SingletonWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }

        /// Generic window, app can create as many of these as it likes but if one with the same title exists it will be raised instead of creating a new one
        /// - handled by `handlesExternalEvents(preferring: allowing:)` in the GenericView itself
        WindowGroup {
            GenericView()
                .environmentObject(appModel)
                .background { HostingWindowFinder(callback: appModel.addGenericWindow) }
        }
        .handlesExternalEvents(matching: [AppConfig.GenericWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }
    }
}
