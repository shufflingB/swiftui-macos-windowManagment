# swiftuiWindowFun

As of 2022/03 - SwiftUI's built in Window management via WindowGroup and Scene's is very limited. Many basic window operations are not available and require ugly code that drops to AppKit to achieve. 

This is one of two similar functionallity demo apps that aims to explore working around these limitations.

In particular, this app attempts to maximise the use of SwiftUI and its life-cycle and to minimise direct usage of AppKit. 

The other application, moreSwiftuiWindowFun - by way of a contrast - adopts an AppKit centric life-cycle with SwiftUI being limited to rendering the UI.  


## macOS window based operations demonstrated by the app



1. Creating and maintaining a single, unclosable main window.
    - Non-closable, ever present across restarts.
    - Restores on restart.
    - Close button removed from window chrome.
    - Menu close window options respond to window selection appropriately.

2. Singleton secondary.
    - Closable.
    - Restores on restart
    - Only ever a single instance.
    - If existing instance, attempts to create new then raises existing instead.
    - Menu items to create and close windows respond appropriately.

3. Generic window creation with remote raising and closing.
    - Closable
    - Instances restore on restart.
    - Windows given identifiable titles.
    - Menu items to create and close windows respond correctly. 


4. App menu creation and entry validation along with keyboard shortcuts operates as would be expected for each window type.

5. App URI scheme and routing

    - Open or raise a singleton window - [swiftuiWindowFun://singleton](swiftuiWindowFun://singleton)
    - Open and route to a generic window - [swiftuiWindowFun://generic?title=Spock](swiftuiWindowFun://generic?title=Spock)


## Approach

App attempts to use SwiftUI to maximum extent possible but goes under the covers to get hold of a 
`NSWindow` reference to enable it to add missing macOS standard control and customisation functioinallity.

Specifically ...

- Uses openURL to spawn new windows in conjunction with `.handlesExternalEvents(preferring: allowing:)` where
necessary to provide singleton windows. Window opening and routing is done in `AppModel`.

- The underlying `AppKit NSWindow` is obtained by using SwiftUI's `NSViewRepresentable` to add a hidden diagnostic `NSView` to the  window's render tree and pull the information from the that. See `HostingWindowFinder` for implementation, and `MainView`, `SingletonView` and `GenericView` for how it's been incorporated.

- References to individual windows and control over what can be closed and post close cleaning operations is done 
via `NSWindow` delegation. See `AppModel` and its extension `AppModel+NSWindowDelegat`. 

- Menu options set out in `FileMenuCommands` use a functionallity from `AppModel` to manage windows and control available menu options.

## Known bugs

1) The window titles for the "generic windows" are current being set when they are created 
and they should be persisting in SceneStorage between app restarts. However that doesn't work, and generic 
windows that get restarted just display the default title value. More on this bug and workarounds in
`GenericView`.   


2) POSSIBLE SINGLETON DEAL BREAKER - If use hosting window finder in conjunction with `.handlesExternalEvents(preferring: allowing:)` then it currently incorrectly allows the launching of multiple singleton windows, i.e. [swiftuiWindowFun://singleton](swiftuiWindowFun://singleton) will create additional windows ad infinitum. 

How to fix - Not sure. 

Anything that attempts to inserts a NSViewRespresentable (even when the view that its makeNSView returns is the same) 
seems to cause handlesExternalEvent(preferring:, matching:) to think the existing instance is incapable of handling the new openURI request.

Random ideas ...
- Stop relying on handeExternalEvents(preferring:, matching:) to ensure single instance and instead programatically alter the outer WindowGroup's .handlesExternalEvents(matching:) so that it no longer routes.
- Try to understand and fix the so that HostingWindowFinder does not cause forkage - why does the system think that there is not an existing window in the system that can handle the request and it needs to create a new one?

 


