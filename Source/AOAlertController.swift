//
//  AlertController.swift
//  CloudKeeper
//
//  Created by Олег Адамов on 08.04.16.
//  Copyright © 2016 AdamovOleg. All rights reserved.
//

import UIKit


class AOAlertController: UIViewController {

    private let containerSize = CGSize(width: 270, height: 104)
    private let actionItemHeight: CGFloat = 44
    private var container = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .OverCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        self.view.alpha = 0
        self.configureContainer()
    }
    
    
    func presentOn(viewController: UIViewController?) {
        guard let parentController = viewController else {
            print("Parent ViewController is nil!")
            return
        }
        parentController.presentViewController(self, animated: false) { [weak self] in
            self?.showUp()
        }
    }

    
    //MARK: - Private 
    
    private func configureContainer() {
        //  white rounded rectangle
        let cFrame = CGRect(x: round((UIScreen.mainScreen().bounds.width - containerSize.width)/2), y: round((UIScreen.mainScreen().bounds.height - containerSize.height)/2), width: containerSize.width, height: containerSize.height)
        self.container = UIView(frame: cFrame)
        self.container.backgroundColor = UIColor.whiteColor()
        self.container.layer.cornerRadius = 11
        self.container.alpha = 0
        self.container.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.view.addSubview(self.container)
        
        //  horizontal line
        let hLine = UIView(frame: CGRect(x: 0, y: 60, width: containerSize.width, height: 0.5))
        hLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.81, alpha: 1)
        self.container.addSubview(hLine)
        
        //  vertival line
        let vLine = UIView(frame: CGRect(x: containerSize.width/2 - 0.5, y: 60, width: 0.5, height: containerSize.height - 60))
        vLine.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.81, alpha: 1)
        self.container.addSubview(vLine)
    }
    
    private func showUp() {
        UIView.animateWithDuration(0.2, animations: { 
            self.view.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .CurveEaseInOut, animations: {
            self.container.alpha = 1
            self.container.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}
