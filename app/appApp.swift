//
//  appApp.swift
//  app
//
//  Created by Muune on 2022/12/05.
//

import SwiftUI


@main
struct appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = MainViewModel()
    
    @State var isShowToast : Bool = false
    @State var toastMsg : String = ""
    @State var isTop : Bool = false
    
    
    @State private var networkConnectd = true
    @State var jsAlert : JsAlert?
    @State var alertModel : AlertModel = AlertModel("","","",.hide)
    @State var shouldShowAlert = false
    @State var isLoading : Bool = false
    @State var textString = ""
    
    init() {
        print("init")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView {
                    ZStack{
                        Color.white.edgesIgnoringSafeArea(.bottom)
                        SettingView()
                        if viewModel.state != .completed {
                            LaunchScreenView()
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
                .environmentObject(viewModel)
                .navigationViewStyle(StackNavigationViewStyle())
                .alert(item: $jsAlert, content: { alert in
                    createAlert(alert)
                })
                
                if self.shouldShowAlert{ createTextAlert() }
                if self.isLoading{ LoadingScreenView().edgesIgnoringSafeArea(.all) }

                if(!networkConnectd){
                    InternetErrorView().edgesIgnoringSafeArea(.all)
                }

                /* Custom Alert */
                if self.alertModel.type != .hide {
                    CustomAlert(alertModel: $alertModel).edgesIgnoringSafeArea(.all)
                }
                
                /* Toast */
                MyToastView(toastMsg: $toastMsg, isShowToast: $isShowToast, isTop: $isTop)
                
            }
            .onReceive(viewModel.toastEvent, perform: { msg in
                self.showToast(msg: msg, isTop: false)
            })
            .onReceive(viewModel.toastEventTop, perform: { msg in
                self.showToast(msg: msg, isTop: true)
            })
            .onReceive(viewModel.jsAlertEvent, perform: { jsAlert in
                viewModel.log(value: "ContentView - jsAlert: \(jsAlert)")
                self.jsAlert = jsAlert
            })
            .onReceive(viewModel.alertEvent, perform: { alert in
                self.alertModel = alert
            })
            .onReceive(viewModel.shouldShowIndicator, perform: { isLoading in
                viewModel.log(value: "ContentView - isLoading: \(isLoading)")
                self.isLoading = isLoading
            })
            .onAppear{
                /* font family 확인용
                for family: String in UIFont.familyNames {
                    print(family)
                    for names : String in UIFont.fontNames(forFamilyName: family){
                        print("=== \(names)")
                    }
                }*/
                
                // 스플래쉬 화면 0.5초 뒤에 사라지도록 처리
                DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.5){
                    viewModel.mainViewShow()
                }
                
                NetworkMonitor.shared.startMonitoring(callBack:networkCheck)
            }
        }
    }
}


extension appApp {
    
    // 토스트 보이기
    func showToast(msg: String, isTop: Bool) {
        self.toastMsg = msg
        self.isTop = isTop
        self.isShowToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            withAnimation(.easeOut(duration: 0.5)) {
                self.isShowToast = false
            }
        })
    }
    
    // 얼럿창 띄우기
    func createAlert(_ alert: JsAlert) -> Alert {
        Alert(
            title: Text(alert.type.description),
            message: Text(alert.message),
            dismissButton: .default(Text("확인"),
            action: {
                viewModel.log(value: "알림창 확인 버튼이 클릭되었다.")
            }))
    }
    
    // 텍스트 입력 얼럿창
    func createTextAlert() -> MyTextAlertView {
        MyTextAlertView(textString: $textString, showAlert: $shouldShowAlert, title: "iOS->Js 보내기", message: "")
    }
    
    
    func networkCheck(isConected: Bool){
        networkConnectd = isConected
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // something to do
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window:UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
