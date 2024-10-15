//
//  InternetErrorView.swift
//  app
//
//  Created by Muune on 2022/12/13.
//

import SwiftUI

struct InternetErrorView: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Image("img_error").centerCropped()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                Text("지금 이 서비스와\n연결할 수 없습니다.").multilineTextAlignment(.center)
                    .font(Font.custom(Constants.fontBold, size:28))
                    .foregroundColor(Color.white)
                    .lineSpacing(1.5)
                Text("문제를 해결하기 위해 노력하고 있습니다.\n잠시 후 다시 확인해주세요.").multilineTextAlignment(.center)
                    .font(Font.custom(Constants.fontBold, size:16)).padding(.top, 16)
                    .foregroundColor(Color.white)
                    .lineSpacing(2)
            }.padding(40)
        })
    }
}

struct InternetErrorView_Previews: PreviewProvider {
    static var previews: some View {
        InternetErrorView()
    }
}
