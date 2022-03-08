//
//  swiftuiWindowFunApp.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 09/02/2022.
//

import Combine
import SwiftUI

@main
struct AppRoot: App {
    @StateObject var appModel = AppModel.shared

    /// App maintains three window groups
    /// - First is a main, permanently open window. This cannot be closed and there is no way in the app to create a new one.
    /// - Second is a singleton window. This can be closed but only a single instance of it may exists at one time
    /// - Thid is a generic window, many of which can be spawned and closed as needed.

    var body: some Scene {
        /// Default, permanent, non-closable, no way to create new one.  in the app "main: window. As there is no way to
        /// create new instance there is no need for the handlesExternalEvents modifier to be used to enforce it's singleton'ness
        /// (as there is with the other window in the the app)
        WindowGroup(AppModel.permanentWinConfig.title) {
            MainView()
                .environmentObject(appModel)
        }
        .handlesExternalEvents(matching: [AppModel.permanentWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }

        /// Singleton window
        WindowGroup(AppModel.singletonWinConfig.title) {
            SingletonView()
                .environmentObject(appModel)
                .handlesExternalEvents( // <- This used so that we only ever get one window
                    preferring: [AppModel.singletonWinConfig.uriHost],
                    allowing: [AppModel.singletonWinConfig.uriHost]
                )
        }
        .handlesExternalEvents(matching: [AppModel.singletonWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }

        /// Generic window, app can create as many of these as it likes
        WindowGroup() {
            GenericView()
                .environmentObject(appModel)
        }
        .handlesExternalEvents(matching: [AppModel.genericWinConfig.uriHost])
        .commands {
            FileMenuCommands(appModel: appModel)
        }
    }
}
