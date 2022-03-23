//
//  Window2.swift
//  moreSwiftuiWindowFun
//
//  Created by Jonathan Hume on 17/02/2022.
//

import SwiftUI

/// An example ever present, single instnace view  intended to act a demo for an app main window type of thing.
struct SingletonView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        VStack {
//            HostingWindowFinder { newWindow in
//                if appModel.singletonNSWindow == nil {
//                    appModel.setSingletonWindow(newWindow)
//                }
//            }

            Text("Hello from the singleton window")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .handlesExternalEvents(  /// Any instance of this view, raise it rather than create it afresh
            preferring: [AppConfig.SingletonWinConfig.uriHost],
            allowing: [AppConfig.SingletonWinConfig.uriHost]
        )
    }
}

/// Disadvantage with opening windows via the openURL is we can't do previews for something like this. Workaround for more complex cases is to split the view
/// into an State and Pure view components, as is demonstrated with `PermanentView` and `PermanentPureView` .
