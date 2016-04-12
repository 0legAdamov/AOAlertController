//
//  ViewController.swift
//  AOAlertController-Example
//
//  Created by Олег Адамов on 08.04.16.
//  Copyright © 2016 Oleg Adamov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Examples"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: self.showWithoutActions()
            case 1: self.showOneAction()
            case 2: self.showTwoActions()
            case 3: self.showThreeActions()
            default: break
            }
        case 1:
            test()
        default: break
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func test() {
        let alert = UIAlertController(title: "No actions", message: "Tap around the alert", preferredStyle: UIAlertControllerStyle.Alert)
//        let action1 = UIAlertAction(title: "Action 1", style: UIAlertActionStyle.Default, handler: nil)
        let action2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let action3 = UIAlertAction(title: "Action 2", style: UIAlertActionStyle.Destructive, handler: nil)
//        alert.addAction(action1)
        alert.addAction(action3)
        alert.addAction(action2)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    // MARK: - alert style
    
    func showWithoutActions() {
        let alert = AOAlertController(title: "No actions", message: "Tap around the alert", style: .Alert)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    func showOneAction() {
        let alert = AOAlertController(title: "One action", message: "One .Default action", style: .Alert)
        let action = AOAlertAction(title: "Done", style: .Default, handler: nil)
        alert.addAction(action)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    func showTwoActions() {
        let alert = AOAlertController(title: "Two actions", message: ".Default and .Destructive action", style: .Alert)
        let actionDef   = AOAlertAction(title: "Done", style: .Default, handler: nil)
        let actionDestr = AOAlertAction(title: "Remove", style: .Destructive, handler: nil)
        alert.addAction(actionDef)
        alert.addAction(actionDestr)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    
    func showThreeActions() {
        let alert = AOAlertController(title: "Three actions", message: "With .Default and\n.Cancel actions", style: .Alert)
        let action1 = AOAlertAction(title: "Action 1", style: .Default, handler: nil)
        let action2 = AOAlertAction(title: "Action 2", style: .Default, handler: nil)
        let cancelAction = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action1)
        alert.addAction(action2)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
}

