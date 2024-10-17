//
//  ScanQRView.swift
//  app
//
//  Created by Quang Nguyễn on 16/10/24.
//

import SwiftUI
import Foundation
import AVFoundation


struct ScanQRView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var mainViewModel: MainViewModel

    @ObservedObject var viewModel: ScanQRViewModel = ScanQRViewModel()
    
    @State var scanResult = ""
    @State var cameraPosition = AVCaptureDevice.Position.back
    
    @State var holeW: Double = 400
    @State var holeH: Double = 400
    @State var holeTop: Double = 300
    @State var maskRect: CGRect? = nil
    
    var body: some View {
        ZStack {
            CBScanner(
                supportBarcode: .constant([.qr]),
                scanInterval: .constant(3.0),
                cameraPosition: $cameraPosition,
                focusZone: $maskRect
            ) {
                guard viewModel.isShowPopupError == false else { return }
                print("BarCodeType =", $0.type.rawValue, "Value =", $0.value)
                scanResult = $0.value
                viewModel.checkQRCode(qrResult: $0.value)
            }
            .onAppear {
                maskRect = CGRect(x: (UIScreen.screenWidth - holeW) / 2,
                                  y: holeTop,
                                  width: holeW,
                                  height: holeH)
            }
            
            BlurView(style: .dark)
                .mask(
                    Hole(maskRect: maskRect)
                        .fill(style: FillStyle(eoFill: true))
                )
            
            VStack {
                VStack{}
                    .frame(width:400, height:400)
                    .border(Color.primary_1)
                    .padding(.top, 300)
                
                Text("QR 코드를 안내선안에 위치해 주세요.")
                    .font(Font.custom(Constants.fontBold, size:28))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 60)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        cameraPosition = cameraPosition == .back ? .front : .back
                    }) {
                        RoundIconButton(icon: "change_camera")
                    }
                    
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        RoundIconButton(icon: "setting")
                            .padding(.leading, 50)
                            .padding(.trailing, 50)
                    }
                    
                    NavigationLink(destination: HistoryCouponView().navigationBarHidden(true)) {
                        RoundIconButton(icon: "log")
                    }
                    
                }.padding(.bottom, 120)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        .alert(isPresented: $viewModel.isShowPopupError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.mesagePopup),
                dismissButton: .default(Text("Cancel"), action: {
                    viewModel.isShowPopupError = false
                })
            )
        }
        
        .fullScreenCover(isPresented: $viewModel.isPresentedCouponDetail) {
            print("dismis")
        } content: {
            CouponDetailView(viewModel: .init(
                qrResult: scanResult,
                couponDetail: viewModel.couponDetail
            ))
        }
    }
}

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
