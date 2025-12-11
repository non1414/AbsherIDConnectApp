//
//  AbsherIDConnectAppApp.swift
//  AbsherIDConnectApp
//
//  Created by نوف بخيت الغامدي on 09/06/1447 AH.
//

import SwiftUI

@main
struct YourAppNameApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashVideoDemoView(showSplash: $showSplash)
            } else {
                AbsherConnectDemoView()
            }
        }
    }
}
