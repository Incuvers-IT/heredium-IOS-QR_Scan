//
//  LogInfo+CoreDataProperties.swift
//  app
//
//  Created by Muune on 2023/03/08.
//
//

import Foundation
import CoreData


extension LogInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogInfo> {
        return NSFetchRequest<LogInfo>(entityName: "LogInfo")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var time: String?
    @NSManaged public var person: Int16
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var sortId: Int16

}

extension LogInfo : Identifiable {

}
	
