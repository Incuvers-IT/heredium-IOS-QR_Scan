//
//  MyToastView.swift
//  app
//
//  Created by Muune on 2022/12/13.
//

import SwiftUI

struct MyToastView: View {
    @Binding var toastMsg: String
    @Binding var isShowToast: Bool
    @Binding var isTop: Bool
    
    var body: some View {
        HStack(alignment:.bottom){
            HStack(spacing: 8){
                Image("check_primary")
                Text(self.toastMsg)
                    .font(Font.custom(Constants.fontMedium, size:13))
                    .foregroundColor(Color.white)
            }
            .frame(height: 44)
            .padding([.leading, .trailing], 24)
            .background(Color.black_11)
            .cornerRadius(33.0)
            .padding(.bottom, 92)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isTop ? .top : .bottom)
        .opacity(self.isShowToast ? 1 : 0)
    }
}


