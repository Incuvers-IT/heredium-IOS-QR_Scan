//
//  QRView.swift
//  app
//
//  Created by Muune on 2023/02/28.
//

import SwiftUI
import Foundation
import AVFoundation


struct QRView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel : MainViewModel
    
    @FetchRequest(entity: LogInfo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LogInfo.sortId, ascending: true )])
    var logs: FetchedResults<LogInfo>
    
    @State var vm = PlayViewModel()
    
    @State var scanResult = "No QR code detected"
    @State var cameraPosition = AVCaptureDevice.Position.back
    
    @State var holeW: Double = 400
    @State var holeH: Double = 400
    @State var holeTop: Double = 300
    @State var maskRect: CGRect? = nil
    
  
    
    var body: some View {
        
        ZStack {
            CBScanner(
                supportBarcode: .constant([.qr]), //Set type of barcode you want to scan
                scanInterval: .constant(3.0), //Event will trigger every 3 seconds
                cameraPosition: $cameraPosition,  //Bind to switch front/back camera
                focusZone: $maskRect
            ){
                //When the scanner found a barcode
                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                scanResult = $0.value
                let data = Data(scanResult.utf8)
                
                viewModel.log(value: "data:\(data)")
                
                do {
                    // パースする
                    let items = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                    
                    guard let uuid = items["uuid"] as? String, !uuid.isEmpty else {
                        viewModel.toastEventTop.send("사용할 수 없는 QR코드입니다.")
                        vm.play(fileNamed: "qr_fail", type: "mp3")
                        viewModel.log(value: "uuid EMPTY")
                        return
                    }
                    
                    guard let id = items["id"] as? Int, id != nil else {
                        viewModel.toastEventTop.send("사용할 수 없는 QR코드입니다.")
                        vm.play(fileNamed: "qr_fail", type: "mp3")
                        viewModel.log(value: "id EMPTY")
                        return
                    }
                    
                    viewModel.log(value: "id:\(id) uuid:\(uuid)")
                    
                    viewModel.qrCheck(context: self .moc, logCount: logs.count, id: id, uuid: uuid){ isOk in
                        //let randomInt = Int.random(in: 1..<5)
                        if(isOk){
                            vm.play(fileNamed:  "qr_check", type: "mp3")
                        }else{
                            vm.play(fileNamed: "qr_fail", type: "mp3")
                        }
                    }
                } catch {
                    viewModel.toastEventTop.send("사용할 수 없는 QR코드입니다.")
                    vm.play(fileNamed: "qr_fail", type: "mp3")
                    print(error)
                }
            }
            .onAppear{
                maskRect = CGRect(x:(UIScreen.screenWidth - holeW)/2, y: holeTop, width: holeW, height: holeH)
                viewModel.log(value: "maskRect:\(maskRect)", UIScreen.screenWidth, UIScreen.screenHeight)
                //print("maskRect\(maskRect)\(UIScreen.screenWidth)")
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
                    
                if(Constants.isDebug){
                    Text(viewModel.log)
                        .bold()
                        .lineLimit(5)
                        .padding()
                }
                
    
                Spacer()
                
                HStack {
                    Button(action:{
                        if cameraPosition == .back {
                            cameraPosition = .front
                        }else{
                            cameraPosition = .back
                        }
                    }){
                        RoundIconButton(icon: "change_camera")
                    }
                    
                    Button(action:{
                        self.mode.wrappedValue.dismiss()
                    }){
                        RoundIconButton(icon: "setting")
                           .padding(.leading, 50)
                           .padding(.trailing, 50)
                    }
                    
                    
                    NavigationLink(
                        destination: LogView().navigationBarHidden(true)
                    ){
                        RoundIconButton(icon: "log")
                    }
                    
                }.padding(.bottom, 120)
            }
        }.edgesIgnoringSafeArea(.all)
            .onAppear{
                //viewModel.log(value: "appear")
            }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}



struct BlurView:UIViewRepresentable{
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(
            effect: UIBlurEffect(style: style)
        )
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // do nothing
    }
}
        
        
struct Hole: Shape {
    @State var maskRect: CGRect?

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addRect(UIScreen.main.bounds)
        if let mask = maskRect{
            path.addRoundedRect(in: mask, cornerSize: CGSize(width: 0, height: 0))
        }
        
        return path
    }
}



struct RoundIconButton: View {
    @State var icon:String
    
    var body: some View {
        VStack{
            Image(icon)
                .imageScale(.large)
                .foregroundColor(Color.white)
                .padding()
        }
        .frame(width: 100, height: 100)
        .background(Color.black_11)
        .cornerRadius(50)
    }
}
