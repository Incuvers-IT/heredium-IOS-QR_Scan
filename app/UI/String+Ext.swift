//
//  String+Ext.swift
//  app
//
//  Created by Muune on 2022/12/05.
//

import Foundation

extension String {
    
    // mime type 을 가져오는 메소드
    func getReadableMimeType() -> String {
        print("String - getReadableMimeType()")
        if let mimeType = mimeTypes.first(where: { (key: String, value: String) in
            value == self
        }) {
            return mimeType.key
        } else {
            return "unknown"
        }
    }
}
