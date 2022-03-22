//
//  Config.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 22/03/2022.
//
import SwiftUI


struct AppConfig {
    /// This needs to be set to be the same as  the Project's Target -> Info -> Url Type configurarion
    static let UrlSchemeName = "swiftuiWindowFun"
    static let UrlTitleQuerryItemKey = "title"
    
    /// Window title's (or placeholder) and hostname part of the uri that is to get used to route to that window
    static let PermanentWinConfig = WindowConfig(title: "Permanent main window", uriHost: "main")
    static let SingletonWinConfig = WindowConfig(title: "Singleton window", uriHost: "singleton")
    static let GenericWinConfig = WindowConfig(title: "Placeholder generic window title", uriHost: "generic")

    // Keyboard shortcuts
    static let NewSingleWindow = KeyboardShortcut("1", modifiers: .command)
    static let NewGenericWindow = KeyboardShortcut("2", modifiers: .command)
    static let WindowClose = KeyboardShortcut("W", modifiers: .command)

    
    
    /// Set up a list of names to give to generic windows and tabs to make them a bit easier to distinguish and show how the URL routing and decoding works
    static let TestWindowNamesForTabsAndGenericWindows: Array<String> = [
        "Kirk", "Checkov", "McCoy", "Scotty", "Spock", "Sulu", "Uhura", "Pike", "Away Team Dude",
        "Picard", "Riker", "La Forge", "Yar", "Worf", "Crusher", "Troi", "Data", "Q", "O'Brien", "Hugh", "Troi",
        "Sisko", "Quark", "Dax", "Janeway", "Chakotay", "Torres", "Paris", "The Doctor", "Tuvok", "Kim", "Seven of Nine",
    ]

    
}
