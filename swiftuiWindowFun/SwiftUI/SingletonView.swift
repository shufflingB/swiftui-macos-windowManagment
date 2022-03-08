//
//  Window2.swift
//  moreSwiftuiWindowFun
//
//  Created by Jonathan Hume on 17/02/2022.
//

import SwiftUI

struct SingletonView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        ZStack {
            HostingWindowFinder { newWindow in
                if appModel.singletonNSWindow == nil {
                    appModel.setSingletonWindow(newWindow)
                }
            }

            Text("Hello from the singleton window")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Window2_Previews: PreviewProvider {
    static var previews: some View {
        SingletonView()
    }
}
