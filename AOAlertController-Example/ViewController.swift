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


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0: self.alertWithoutActions()
            case 1: self.alertOneAction()
            case 2: self.alertTwoActions()
            case 3: self.alertThreeActions()
            default: break
            }
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0: self.sheetOneAction()
            case 1: self.sheetTwoActions()
            case 2: self.sheetThreeActions()
            default: break
            }
        default: break
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - alert style
    
    func alertWithoutActions() {
        let alert = AOAlertController(title: "No actions", message: "Tap around the alert", style: .alert)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    func alertOneAction() {
        let alert = AOAlertController(title: "One action", message: "One .Default action", style: .alert)
        alert.titleColor = UIColor.red
        alert.titleFont = UIFont(name: "AvenirNext-Bold", size: 14)!
        let action = AOAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    func alertTwoActions() {
        let alert = AOAlertController(title: "Two actions", message: nil, style: .alert)
        let actionDef   = AOAlertAction(title: "Default", style: .default, handler: nil)
        let actionCancel = AOAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionCancel.color = UIColor.orange
        alert.addAction(actionDef)
        alert.addAction(actionCancel)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    
    func alertThreeActions() {
        let alert = AOAlertController(title: "Three actions", message: "With .Destructive and\n.Cancel actions", style: .alert)
        alert.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
        alert.titleColor = UIColor.white
        alert.messageColor = UIColor.lightGray
        alert.linesColor = UIColor.darkGray
        let action1 = AOAlertAction(title: "Remove", style: .destructive, handler: nil)
        action1.color = UIColor.white
        let action2 = AOAlertAction(title: "Remove all", style: .destructive, handler: nil)
        action2.color = UIColor.white
        let cancelAction = AOAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.color = UIColor.white
        alert.addAction(cancelAction)
        alert.addAction(action1)
        alert.addAction(action2)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    
    // MARK: - actionsheet stye
    
    
    func sheetOneAction() {
        let alert = AOAlertController(title: "One action", message: "default appearance", style: .actionSheet)
        let cancel = AOAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    
    func sheetTwoActions() {
        let alert = AOAlertController(title: "Two actions", message: "custom actions color", style: .actionSheet)
        let action1 = AOAlertAction(title: "Action 1", style: .default, handler: nil)
        action1.color = UIColor.orange
        let action2 = AOAlertAction(title: "Action 2", style: .default, handler: nil)
        action2.color = UIColor.darkGray
        alert.addAction(action1)
        alert.addAction(action2)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
    
    
    func sheetThreeActions() {
        let alert = AOAlertController(title: "Three actions", message: nil, style: .actionSheet)
        alert.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 1)
        alert.linesColor = UIColor.darkGray
        alert.titleColor = UIColor.white
        let defaultAction = AOAlertAction(title: "Default action", style: .default, handler: nil)
        defaultAction.color = UIColor.lightGray
        let cancelAction = AOAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.color = UIColor.yellow
        let destrAction = AOAlertAction(title: "Destructive", style: .destructive, handler: nil)
        destrAction.color = UIColor.orange
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(destrAction)
        self.navigationController?.present(alert, animated: false, completion: nil)
    }
}

