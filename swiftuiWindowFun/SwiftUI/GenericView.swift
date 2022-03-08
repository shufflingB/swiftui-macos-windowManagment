//
//  Generic.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 25/02/2022.
//

import SwiftUI

struct GenericView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.scenePhase) private var scenePhase

    // TODO: Bug --
    /// Does not restore the title that was previously set through onOpenUrl  because of something to
    /// do with using  HostingWindowFinder i.e. take that out and it works (but then nothing else does ...) .
    /// Possible workaround include:
    /// - Hide the bug by closing the windows prior to exit.
    /// - Derive the title from the contents displayed and remove dependency on SceneStorage working.
    
    @SceneStorage("navtitle") private var navTitle: String?

    @State var thisViewWindow: NSWindow? = nil

    var body: some View {
        ZStack {
            HostingWindowFinder(callback: { foundWin in
                appModel.addGenericWindow(foundWin)
                thisViewWindow = foundWin
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

struct Generic_Previews: PreviewProvider {
    static var previews: some View {
        GenericView()
    }
}
