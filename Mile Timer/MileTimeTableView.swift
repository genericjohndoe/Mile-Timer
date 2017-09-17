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
            print("Failed to initialize FetchedResultsController: \(error)")
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miletimes", for: indexPath)
        // Set up the cell
        let object = self.fetchedResultsController?.object(at: indexPath)
        //Populate the cell from the object
        print("\((object?.minpermile))")
        cell.textLabel?.text = "\((object?.minpermile)!)"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //print(fetchedResultsController.sections!.count)
        //return fetchedResultsController.sections!.count
        if let frc = fetchedResultsController {
            return frc.sections!.count
        }
        print("frc is nil")
        return 0
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    

}
