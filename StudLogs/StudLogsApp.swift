//
//  StudLogsApp.swift
//  StudLogs
//
//  Created by admin on 10/02/23.
//

import SwiftUI

@main
struct StudLogsApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    SplashView()
                }
            } else {
                NavigationView {
                    SplashView()
                }
                .phoneOnlyStackNavigationView()
            }
        }
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
