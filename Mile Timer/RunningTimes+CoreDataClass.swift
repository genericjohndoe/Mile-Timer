//
//  RunningTimes+CoreDataClass.swift
//  
//
//  Created by joel johnson on 9/12/17.
//
//

import Foundation
import CoreData


public class RunningTimes: NSManagedObject {
    
    convenience init(minpermile: Double, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "RunningTimes", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.minpermile = minpermile
            
        } else {
            fatalError("Unable To Find Entity Name!")
        }
    }

}
