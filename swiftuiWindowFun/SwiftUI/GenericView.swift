//
//  Generic.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 25/02/2022.
//

import SwiftUI

struct GenericView: View {
    @EnvironmentObject var appModel: AppModel
    @SceneStorage("navtitle") private var navTitle: String = "Not set"
    
    var body: some View {
        VStack {
            Text("Hello from generic window \(navTitle)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(navTitle)
        .onOpenURL(perform: { url in
            print("Got opened from a URL \(url)")
            navTitle = AppModel.titleFromUrl(url) ?? "Set failed"
        })
        .handlesExternalEvents(preferring: [navTitle], allowing: [navTitle]) /// Any instance of this view AND with this title, then raise rather than
        /// create a new instance
    }
}

/// See note on  previews in `SingletonView`
