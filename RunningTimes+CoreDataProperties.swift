//
//  RunningTimes+CoreDataProperties.swift
//  
//
//  Created by joel johnson on 9/12/17.
//
//

import Foundation
import CoreData


extension RunningTimes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunningTimes> {
        return NSFetchRequest<RunningTimes>(entityName: "RunningTimes")
    }

    @NSManaged public var minpermile: Double

}
