//
//  SplashView.swift
//  StudLogs
//
//  Created by admin on 23/05/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isInActive = false
    @State var scale = 1.0
    
    var body: some View {
        ZStack {
            
            Image("roll-call")
                .resizable()
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .animation(.linear(duration: 1), value: scale)
            NavigationLink(destination: LoginView(), isActive: $isInActive) {}
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                scale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isInActive = true
            }
        }
    }
        
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
