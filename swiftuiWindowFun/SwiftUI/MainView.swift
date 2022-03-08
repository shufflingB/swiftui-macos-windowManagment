//
//  Main.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 16/02/2022.
//

import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        ZStack {
            HostingWindowFinder(callback: appModel.setPermanentWindow)

            VStack {
                Text("Hello from the app's main window")

                Button("Create or raise singleton window") {
                    appModel.openOrRaiseSingletonWindow()
                }

                Button("Create new generic window") {
                    appModel.openGenericWindow()
                }

                /// Not sure why, but List does not work here - possibly because of Zstack
                ForEach(appModel.genericNSWindows, id: \.self) { (genericWindow: NSWindow) in
                    HStack {
                        Text("\(genericWindow.windowNumber)")

                        Text("\(genericWindow.title)")

                        Button("Raise") {
                            genericWindow.makeKeyAndOrderFront(nil)
                        }

                        Button("Close") {
                            genericWindow.close()
                        }
                    }
                }

                .fixedSize()
            }
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        .onChange(of: appModel.permanentNSWindow, perform: { newValue in
            /// Hide the close button - it would be nice to create it without but using url to create means we currently do not have access a-priori
            if let newValue = newValue {
                newValue.standardWindowButton(.closeButton)?.isHidden = true
            }
        })
    }
}
