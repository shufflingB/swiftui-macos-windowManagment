//
//  FileCommands.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 22/02/2022.
//

import SwiftUI

struct FileMenuCommands: Commands {
    @ObservedObject var appModel: AppModel // = AppModel.shared

    @State var keyWindow: NSWindow? = nil

    static let newSingleWindow = KeyboardShortcut("1", modifiers: .command)
    static let newGenericWindow = KeyboardShortcut("2", modifiers: .command)
    static let windowClose = KeyboardShortcut("W", modifiers: .command)

    var disableWindowClose: Bool {
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
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button(disableOrRaiseMsg) {
                appModel.openOrRaiseSingletonWindow()
            }
            .keyboardShortcut(Self.newSingleWindow)
            
            Button("New generic window") {
                appModel.openGenericWindow()
            }
            .keyboardShortcut(Self.newGenericWindow)
            
        }

        
        
        
        CommandGroup(replacing: CommandGroupPlacement.saveItem) {
            Button("Close") {
                NSApp.keyWindow?.close()
            }
            .disabled(disableWindowClose)
            .keyboardShortcut(Self.windowClose)
        }
    }
}
