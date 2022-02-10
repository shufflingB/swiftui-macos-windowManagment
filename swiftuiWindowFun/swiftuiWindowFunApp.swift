//
//  swiftuiWindowFunApp.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 09/02/2022.
//

import SwiftUI

@main
struct DemoApp: App {
    @State var appModel = AppModel()

    var body: some Scene {
        WindowGroup("Main") {
            MainContentView()
                .environmentObject(appModel)
                
        }

        WindowGroup("Window 2") {
            WindowContentView2()
                .environmentObject(appModel)
        }
        .handlesExternalEvents(matching: [AppModel.GroupId.win2.rawValue])

        WindowGroup("Window 3") {
            WindowContentView3()
                .environmentObject(appModel)
                .handlesExternalEvents(preferring: [AppModel.GroupId.win3.rawValue],
                                       allowing: [AppModel.GroupId.win3.rawValue])
        }
        .handlesExternalEvents(matching: [AppModel.GroupId.win3.rawValue])
    }
}

struct MainContentView: View {
    @EnvironmentObject var appModel: AppModel
    var body: some View {
        VStack {
            Button("Open many Window 2") {
                appModel.openWindowViaUrl(.win2)
            }

            Button("Open or raise Window 3") {
                appModel.openWindowViaUrl(.win3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WindowContentView2: View {
    var body: some View {
        VStack {
            Text("Window #2")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WindowContentView3: View {
    var body: some View {
        VStack {
            Text("Window #3")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
