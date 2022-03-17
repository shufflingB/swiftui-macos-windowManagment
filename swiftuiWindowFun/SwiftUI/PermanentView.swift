//
//  Main.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 16/02/2022.
//

import Combine
import SwiftUI

struct PermanentView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        ZStack {
            HostingWindowFinder(callback: appModel.setPermanentWindow)

            VStack {
                Text("Hello from the app's main permanent window")
                    .font(.title)

                HStack {
                    Spacer()
                    Button("Create or raise singleton window") {
                        appModel.openOrRaiseSingletonWindow()
                    }
                    .padding()
             
                    Button("Create new generic window") {
                        appModel.openGenericWindow()
                    }
                    .padding()
                    Spacer()
                }

                VStack(alignment: .leading) {
                    Text("Generic windows...")
                        .font(.title3)
                    Text("-----------------------------------")

                    /// Not sure why, but List does not work here - possibly because of Zstack
                    ForEach(Array(appModel.genericNSWindows), id: \.windowNumber) { (genericWindow: NSWindow) in
                        HStack {
                            Text("\(genericWindow.windowNumber)")

                            Text("\(genericWindow.title)")

                            Button("Raise") {
                                genericWindow.makeKeyAndOrderFront(nil)
                            }

                            Button("Close") {
                                genericWindow.performClose(nil)

//                            appModel.genericNSWindows.remove(genericWindow) //<-- Not sure why, but swiftui can't rely on extension to clean up if just uses genericWindow.close
                                // guess would be that running close bypasses the windowShouldClose delegate method.
                            }
                        }
                    }
                    .fixedSize()

                    Text("-----------------------------------")

                    Text("Number of windows: \(appModel.genericNSWindows.count)")
                        .font(.footnote)
                }
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
