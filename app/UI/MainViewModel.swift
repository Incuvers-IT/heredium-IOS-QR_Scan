//
//  WebViewModel.swift
//  app
//
//  Created by Muune on 2022/12/05.
//
import Foundation
import Combine
import UIKit
import SwiftUI
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import CoreData

typealias WEB_NAVIGATION = MainViewModel.NAVIGATION

class MainViewModel: ObservableObject {
    @Published var state: LaunchScreenPhase = .first
    @Published var isFirst: Bool = true
    @Published var log: String = ""
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        return version
    }
    
    func log(value: Any...){
        if(Constants.isDebug){
            log = "\(value)"
            print("Coloso Log : ", value)
        }
    }
    
    func baseUrl() -> String{
        return Constants.isDev ? Constants.BASE_DEV_URL : Constants.BASE_REAL_URL
    }
    
    func qrCheck(context:NSManagedObjectContext, logCount:Int, id:Int, uuid:String, callback:@escaping (Bool)->Void){
        Repository.shared.fetchQRCheck(viewModel: self, id: id, uuid: uuid, allows: self.allowList){ result in
            switch(result){
            case .success(let data):
                self.log(value: "data, \(data)")
                let time = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:ss"
                let stringDate = timeFormatter.string(from: time)
                
                let logInfo = LogInfo(context: context)//LogInfo(context: self .moc)
                logInfo.sortId = Int16(logCount+1)//Int16(logs.count + 1)
                logInfo.email = data.email ?? ""
                logInfo.name = data.name ?? ""
                logInfo.person = Int16(data.number)
                logInfo.time = stringDate
                logInfo.uuid = data.uuid
                
                do {
                    try context.save()
                } catch {
                    self.log(value: "으악 \(error.localizedDescription)")
                }
                
                self.toastEventTop.send("입장권(\(data.number)명)이 사용완료로 변경되었습니다.")
                callback(true)
            case .failure(let err):
                self.log(value: "error, \(err)")
                
                guard let msg = err.BODY, !msg.isEmpty else {
                    return
                }
                self.log(value: "msg\(msg)")
                self.toastEventTop.send(msg)
                callback(false)
            }
        }
    }
    
    
    @Published var exhibitionList: [Project] = Array()
    @Published var programList: [Project] = Array()
    @Published var coffeeList: [Project] = Array()
    @Published var allowList: [Allow] = Array()
    
    func getProjects(){
        Repository.shared.fetchProjects(viewModel: self){ result in
            switch(result){
            case .success(let data):
                self.log(value: "data, \(data)")
                for i in 0..<data.count {
                    if(data[i].kind == "EXHIBITION"){
                        self.exhibitionList.append(data[i])
                    }else if(data[i].kind == "COFFEE"){
                        self.coffeeList.append(data[i])
                    }else if(data[i].kind == "PROGRAM"){
                        self.programList.append(data[i])
                    }
                }
            case .failure(let err):
                self.log(value: "error, \(err)")
            }
        }
    }
    
    func allowListChange(project:Project, isCheck: Bool){
        if(isCheck){
            allowList.append(Allow(id: project.id, kind: project.kind))
        }else{
            allowList = allowList.filter{$0.id != project.id}
        }
    }

    func setCheckAllInit(){
        allowList.removeAll()
    }
    
    func settingListInit(){
        exhibitionList.removeAll()
        programList.removeAll()
        coffeeList.removeAll()
    }

    
    
    enum LaunchScreenPhase {
        case first
        case second
        case completed
    }
    
    enum NAVIGATION {
        case BACK, FORWARD, REFRESH
    }
    
    enum URL_TYPE {
        case HEREDIUM_DEV
        case HEREDIUM
        case HEREDIUM_TICKETING
        case HEREDIUM_DOCENT
        case HEREDIUM_MY
        case TEST
        var url : URL? {
            switch self {
            case .HEREDIUM_DEV: return URL(string: Constants.HEREDIUM_URL_DEV)
            case .HEREDIUM: return URL(string: Constants.HEREDIUM_URL)
            case .HEREDIUM_TICKETING: return URL(string: Constants.HEREDIUM_TICKETING)
            case .HEREDIUM_DOCENT: return URL(string: Constants.HEREDIUM_DOCENT)
            case .HEREDIUM_MY: return URL(string: Constants.HEREDIUM_MY)
            case .TEST: return URL(string: Constants.TEST_URL)
            }
        }
    }
    
    
    func mainViewShow() {
        if(self.state == .first){
            self.state = .second
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.state = .completed
        }
    }
    
    // 웹뷰의 url 이 변경되었을 때 이벤트
    var changedUrlSubject = PassthroughSubject<URL, Never>()
    
    // 웹뷰 네비게이션 액션에 대한 이벤트
    var webNavigationSubject = PassthroughSubject<WEB_NAVIGATION, Never>()
    
    // 웹사이트 타이틀 이벤트
    var webSiteTitleSubject = PassthroughSubject<String, Never>()
    
    // JS -> iOS 함수 호출
    var jsToNativeEvent = PassthroughSubject<String, Never>()
    
    // iOS -> JS 함수 호출(getWifiInfoResult)
    var nativeToGetWifiInfoResultEvent = PassthroughSubject<String, Never>()
    
    // iOS -> JS 함수 호출(permissionDenied)
    var nativeToPermissionDeniedEvent = PassthroughSubject<String, Never>()
    
    // 자바스크립트 alert 이 들어오면 이벤트 보내기
    var jsAlertEvent = PassthroughSubject<JsAlert, Never>()
    
    var alertEvent = PassthroughSubject<AlertModel, Never>()
    
    // Toast
    var toastEventTop = PassthroughSubject<String, Never>()
    var toastEvent = PassthroughSubject<String, Never>()
    
    // 로딩 여부 이벤트
    var shouldShowIndicator = PassthroughSubject<Bool, Never>()
    
    // 파일 다운로드 이벤트
    var downloadEvent = PassthroughSubject<URL, Never>()
    
   
    func getWiFiSsid() -> String? {
        var ssid: String?
        var bssid: String?
        var result: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                print("interface-", interface)
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    bssid = interfaceInfo[kCNNetworkInfoKeyBSSID] as? String
                    if(ssid != nil && bssid != nil){
                        result = "{\"ssid\": \"\(ssid!)\", \"bssid\": \"\(bssid!)\"}"
                    }
                    print("bssid-", bssid)
                    print("ssid-", ssid)
                    break
                }
            }
        }
        return result
    }
}
