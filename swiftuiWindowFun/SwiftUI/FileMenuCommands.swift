//
//  FileCommands.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 22/02/2022.
//

import SwiftUI

struct FileMenuCommands: Commands {
    @ObservedObject var appModel: AppModel

    var disableWindowClose: Bool {
        /// By default, SwiftUI's built in close window will close any window, so we need to be able to toggle that off when we're displaying the permanent window.
        if appModel.permanentNSWindow == appModel.keyWindow {
            return true
        } else {
            return false
        }
    }

    var disableOrRaiseMsg: String {
        if appModel.singletonNSWindow == nil {
            return "New single window"
        } else {
            return "Raise single window"
        }
    }

    var body: some Commands {
        /// NB: The default newItem uses a non-swiftUI  api to create new instances of whatever the first WindowGroup. So if  using
        /// `.handlesExternalEvents(preferring: allowing: )` to do singleton (as here)  this has to be overriden or what's built in will break that functionallity by ignoring
        /// the restriction that only works when items are created via the URI handling mechanism.
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button(disableOrRaiseMsg) {
                appModel.openOrRaiseSingletonWindow()
            }
            .keyboardShortcut(AppConfig.NewSingleWindow)

            Button("New generic window") {
                appModel.openGenericWindow()
            }
            .keyboardShortcut(AppConfig.NewGenericWindow)
        }

        CommandGroup(replacing: CommandGroupPlacement.saveItem) {
            Button("Close") {
                NSApp.keyWindow?.performClose(nil)
            }
            .disabled(disableWindowClose)
            .keyboardShortcut(AppConfig.WindowClose)
        }
    }
}
