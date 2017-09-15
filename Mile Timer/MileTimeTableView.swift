//
//  MileTimeTableView.swift
//  Mile Timer
//
//  Created by joel johnson on 9/10/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MileTimeTableView: UITableViewController, NSFetchedResultsControllerDelegate{
    
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var fetchedResultsController: NSFetchedResultsController<RunningTimes>!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<RunningTimes>(entityName: "RunningTimes")
        let times = NSSortDescriptor(key: "minpermile", ascending: true)
        request.sortDescriptors = [times]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miletimes", for: indexPath)
        // Set up the cell
        let object = self.fetchedResultsController?.object(at: indexPath)
        //Populate the cell from the object
        cell.textLabel?.text = "\(object?.minpermile)"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    

}
