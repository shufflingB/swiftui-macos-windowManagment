//
//  PermanentViewPure.swift
//  swiftuiWindowFun
//
//  Created by Jonathan Hume on 22/03/2022.
//

import SwiftUI

/// Keep state out this so that it's UI can be more easily worked on by using the Preview mechanism.
struct PermanentPureView: View {
    let openOrRaiseSingletonWindow: () -> Void
    let openGenericWindow: () -> Void
    let singleton: NSWindow?
    let genericWins: Set<NSWindow>
    
    
    var body: some View {
        VStack {
            Text("Hello from the app's main permanent window")
                .font(.title)
                .padding()

            HStack {
                Button("New or Raise Singleton") {
                    openOrRaiseSingletonWindow()
                }
                .padding()

                Button("New Generic") {
                    openGenericWindow()
                }
                .padding()

                Button("Close All") {
                    withAnimation {
                        /// NB:  Do not call `close` directly, always call `performClose` or the appModel references will end up incorrect. See explanation in
                        /// `NSWindow+NSWindowDelegate`for explanation
                        singleton?.performClose(nil)
                        genericWins.forEach({ $0.performClose(nil) })
                    }
                }
                .padding()
            }
            VStack {
                Text("Generic Windows").font(.title3)
                Table(Array(genericWins)) {
                    TableColumn("id") { nsWindow in Text(String(nsWindow.windowNumber)) }
                    TableColumn("Title", value: \.title)
                    TableColumn("") { nsWindow in Button("Raise", action: { nsWindow.makeKeyAndOrderFront(nil) }) }
                    /// NB:  Do not call `close` directly, always call `performClose` or the appModel references will end up incorrect. See explanation in
                    /// `NSWindow+NSWindowDelegate`for explanation
                    TableColumn("") { nsWindow in Button("Close", action: { nsWindow.performClose(nil) }) }
                }
                .border(Color.gray)
            }
            .padding()

            Text("Number of windows: \(genericWins.count)").font(.footnote).padding()
        }
    }
}

struct PermanentViewPure_Previews: PreviewProvider {
    static var previews: some View {
        PermanentPureView(
            openOrRaiseSingletonWindow: {}, openGenericWindow: {}, singleton: nil, genericWins: []
        )
    }
}
