//
//  SplashView.swift
//  app
//
//  Created by Muune on 2022/12/05.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
           background
           logo
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(MainViewModel())
    }
}


extension LaunchScreenView {
    var background: some View {
        Color("launch-screen-background")
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View{
        Image("heredium_logo")
    }
}
