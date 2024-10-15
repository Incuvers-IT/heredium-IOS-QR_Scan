//
//  LoadingScreenView.swift
//  app
//
//  Created by Muune on 2022/12/05.
//


import Foundation
import SwiftUI

// 로딩 스크린뷰
struct LoadingScreenView: View {
    var body: some View{
        ZStack(alignment: .center, content: {
            Color.black
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            LoadingIndicatorView()
        })
    }
}
