//
//  NetworkMonitor.swift
//  app
//
//  Created by Muune on 2021/10/18.
//

import Foundation
import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    var connType: ConnectionType = .wifi
    var isOn: Bool = true
    var networkAlertView:(Bool)->() = { isOn in }

    func startMonitoring(callBack:@escaping (Bool)->()) {
        networkAlertView = callBack
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                self?.isOn = true
                callBack(true)
            } else {
                self?.isOn = false
                callBack(false)
            }
            self?.connType = self?.checkConnectionTypeForPath(path) ?? .unknown
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func networkAlert(){
        networkAlertView(self.isOn)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
           if path.usesInterfaceType(.wifi) {
               return .wifi
           } else if path.usesInterfaceType(.wiredEthernet) {
               return .ethernet
           } else if path.usesInterfaceType(.cellular) {
               return .cellular
           }
           return .unknown
       }
}
