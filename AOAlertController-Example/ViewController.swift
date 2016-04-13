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
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "test")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ViewController.test))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: self.alertWithoutActions()
            case 1: self.alertOneAction()
            case 2: self.alertTwoActions()
            case 3: self.alertThreeActions()
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0: self.sheetWithoutActions()
            default: break
            }
        default: break
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func test() {
        let alert = UIAlertController(title: "No actions", message: "Tap around the alert", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        let action1 = UIAlertAction(title: "Action 1", style: UIAlertActionStyle.Default, handler: nil)
        let action2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let action3 = UIAlertAction(title: "Action 2", style: UIAlertActionStyle.Destructive, handler: nil)
//        alert.addAction(action1)
        alert.addAction(action3)
        alert.addAction(action2)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    // MARK: - alert style
    
    func alertWithoutActions() {
        let alert = AOAlertController(title: "No actions", message: "Tap around the alert", style: .Alert)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    func alertOneAction() {
        let alert = AOAlertController(title: "One action", message: "One .Default action", style: .Alert)
        alert.titleColor = UIColor.redColor()
        alert.titleFont = UIFont(name: "AvenirNext-Bold", size: 14)!
        let action = AOAlertAction(title: "Done", style: .Default, handler: nil)
        alert.addAction(action)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    func alertTwoActions() {
        let alert = AOAlertController(title: "Two actions", message: nil, style: .Alert)
        let actionDef   = AOAlertAction(title: "Default", style: .Default, handler: nil)
        let actionCancel = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionCancel.color = UIColor.orangeColor()
        alert.addAction(actionDef)
        alert.addAction(actionCancel)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    
    func alertThreeActions() {
        let alert = AOAlertController(title: "Three actions", message: "With .Destructive and\n.Cancel actions", style: .Alert)
        alert.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightGrayColor()
        alert.linesColor = UIColor.darkGrayColor()
        let action1 = AOAlertAction(title: "Remove", style: .Destructive, handler: nil)
        action1.color = UIColor.whiteColor()
        let action2 = AOAlertAction(title: "Remove all", style: .Destructive, handler: nil)
        action2.color = UIColor.whiteColor()
        let cancelAction = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        cancelAction.color = UIColor.whiteColor()
        alert.addAction(cancelAction)
        alert.addAction(action1)
        alert.addAction(action2)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    
    // MARK: - actionsheet stye
    
    
    func sheetWithoutActions() {
        let alert = AOAlertController(title: "Title", message: "message", style: .ActionSheet)
        let action1 = AOAlertAction(title: "Action 1", style: .Default, handler: nil)
        let cancel = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(cancel)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
}

