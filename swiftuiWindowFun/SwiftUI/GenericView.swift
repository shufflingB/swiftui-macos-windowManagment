//
//  Generic.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 25/02/2022.
//

import SwiftUI

struct GenericView: View {
    @EnvironmentObject var appModel: AppModel
    @SceneStorage("navtitle") private var navTitle: String?

    var body: some View {
        ZStack {
            HostingWindowFinder(callback: { foundWin in
                appModel.addGenericWindow(foundWin)
            })
            VStack {
                Text("Hello from generic window \(navTitle ?? "not set")")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onOpenURL(perform: { url in
            print("Got opened from a URL \(url)")
            navTitle = AppModel.titleFromUrl(url) ?? "Set failed"
        })
        .navigationTitle(navTitle ?? "Not set")
    }
}

/// See note on  previews in `SingletonView`
