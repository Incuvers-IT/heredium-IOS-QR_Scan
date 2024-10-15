//
//  CustomAlert.swift
//  app
//
//  Created by Muune on 2022/12/13.
//

import Foundation
import SwiftUI


struct AlertModel: Identifiable {
    enum TYPE:Int {
        case hide = 0
        case alert = 1
        case confirm = 2
        case error = 3
    }
    
    let id: UUID = UUID()
    var type:TYPE
    var title: String = ""
    var okButton: String = ""
    var cancelButton: String = ""
    
    init(_ title: String, _ okButton: String, _ cancelButton: String, _ type: TYPE) {
        self.title = title
        self.okButton = okButton
        self.cancelButton = cancelButton
        self.type = type
    }
}


struct CustomAlert: View {
    @Binding var alertModel: AlertModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack{
            if(alertModel.type != .hide){
                VStack(alignment: .leading){
                    if(!alertModel.title.isEmpty){
                        Text(alertModel.title)
                            .font(Font.custom(Constants.fontMedium, size:16))
                            .lineSpacing(5)
                            .foregroundColor(Color.black_11)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack{
                        if(!alertModel.cancelButton.isEmpty){
                            Button(action: {
                                alertModel.type = .hide
                            }){
                                Text(alertModel.cancelButton)
                                    .font(Font.custom(Constants.fontBold, size:14))
                                    .foregroundColor(Color.primary_1)
                                    .padding(.vertical, 12)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .border(Color.primary_1, width: 1)
                            }.padding(.trailing, 4)
                        }
                        if(!alertModel.okButton.isEmpty){
                            Button(action: {
                                print("ok")
                                alertModel.type = .hide
                            }){
                                Text(alertModel.okButton)
                                    .font(Font.custom(Constants.fontBold, size:14))
                                    .foregroundColor(Color.white)
                                    .opacity(1)
                                    .padding(.vertical, 12)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color.primary_1)
                            }.disabled(false)
                                .padding(.leading, alertModel.type == .confirm ? 4 : 0)
                        }
                    }.padding(.top, 14)
                }.padding(.horizontal, 20)
                    .padding(.vertical, 36)
                    .frame(maxWidth: 500)
                    .background(Color.white)
                    .padding(.bottom, keyboard.currentHeight*0.5)
            }
        }.padding([.leading, .trailing], 20)
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .edgesIgnoringSafeArea(.all).background(Color.gray_alpha_50)
    }
}
