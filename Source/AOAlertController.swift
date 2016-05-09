//
//  AlertController.swift
//  CloudKeeper
//
//  Created by Олег Адамов on 08.04.16.
//  Copyright © 2016 AdamovOleg. All rights reserved.
//

import UIKit


public class AOAlertSettings {
    
    public static let sharedSettings = AOAlertSettings()
    
    public var titleFont              = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
    public var messageFont            = UIFont.systemFontOfSize(13)
    public var defaultActionFont      = UIFont.systemFontOfSize(16)
    public var cancelActionFont       = UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
    public var destructiveActionFont  = UIFont.systemFontOfSize(16)
    
    public var backgroundColor        = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    public var linesColor             = UIColor(red: 0.8, green: 0.8, blue: 0.81, alpha: 1)
    public var titleColor             = UIColor.blackColor()
    public var messageColor           = UIColor.blackColor()
    public var defaultActionColor     = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    public var destructiveActionColor = UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1)
    public var cancelActionColor      = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    public var actionBackgroundColor  = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    public var blurredBackground      = false
    
    public var tapBackgroundToDismiss = false
}



public enum AOAlertActionStyle {
    case Default, Destructive, Cancel
}


public class AOAlertAction {
    
    public var color: UIColor?
    public var font: UIFont?
    public var backgroundColor: UIColor?
    
    public init(title: String, style: AOAlertActionStyle, handler: (() -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    
    // MARK: - Private
    
    private let title: String
    private let style: AOAlertActionStyle
    private let handler: (() -> Void)?
    private var completion: (() -> Void)?
    
    private func drawOnView(parentView: UIView, frame: CGRect, completion: () -> Void) {
        let textFont  = self.font  ?? self.textFontByStyle()
        let textColor = self.color ?? self.textColorByStyle()
        
        let button = UIButton(frame: frame)
        button.titleLabel?.font = textFont
        button.setTitleColor(textColor, forState: .Normal)
        button.setTitle(self.title, forState: .Normal)
        button.addTarget(self, action: #selector(AOAlertAction.buttonPressed), forControlEvents: .TouchUpInside)
        button.backgroundColor = self.backgroundColor ?? AOAlertSettings.sharedSettings.actionBackgroundColor
        self.completion = completion
        parentView.addSubview(button)
    }
    
    
    @objc private func buttonPressed() {
        self.handler?()
        self.completion?()
    }
    
    
    private func textColorByStyle() -> UIColor {
        switch self.style {
        case .Cancel:      return AOAlertSettings.sharedSettings.cancelActionColor
        case .Default:     return AOAlertSettings.sharedSettings.defaultActionColor
        case .Destructive: return AOAlertSettings.sharedSettings.destructiveActionColor
        }
    }
    
    
    private func textFontByStyle() ->UIFont {
        switch  self.style {
        case .Cancel:      return AOAlertSettings.sharedSettings.cancelActionFont
        case .Default:     return AOAlertSettings.sharedSettings.defaultActionFont
        case .Destructive: return AOAlertSettings.sharedSettings.destructiveActionFont
        }
    }
    
}



public enum AOAlertControllerStyle {
    case Alert, ActionSheet
}


public class AOAlertController: UIViewController {
    
    public var actionItemHeight: CGFloat = 44
    public var backgroundColor: UIColor?
    public var linesColor: UIColor?
    public var titleColor: UIColor?
    public var blurredBackground: Bool?
    public var titleFont: UIFont? {
        didSet {
            if titleFont == nil { print("Error: title font is nil!") }
        }
    }
    public var messageColor: UIColor?
    public var messageFont: UIFont? {
        didSet {
            if messageFont == nil { print("Error: message font is nil!") }
        }
    }
    public var tapBackgroundToDismiss: Bool?
    
    
    public init(title: String?, message: String?, style: AOAlertControllerStyle) {
        self.alertTitle = title
        self.message = message
        self.style = style
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .OverCurrentContext
    }
    
    
    public func addAction(action: AOAlertAction) {
        self.actions.append(action)
    }

    
    //MARK: - Private 
    
    private let style: AOAlertControllerStyle
    private var alertTitle: String?
    private let message: String?
    private let containerWidth: CGFloat = 270
    private let contentOffset: CGFloat = 0
    private let sheetHorizontalOffset: CGFloat = 10
    private let sheetBottomOffset: CGFloat = 9
    private var sheetYOffset: CGFloat = 0
    private let sheetBetweenCancelOffset: CGFloat = 8
    private let containerMinHeight: CGFloat = 60
    private var container = UIView()
    private var cancelContainer: UIView?
    private var actions = [AOAlertAction]()
    private let topAndBottomOffset: CGFloat = 29
    private let alertMessageSideOffset: CGFloat = 20
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let wantsblurredBackground = self.blurredBackground ?? AOAlertSettings.sharedSettings.blurredBackground
        if (wantsblurredBackground) {
            let blur = UIBlurEffect(style: .Light)
            let blurredView = UIVisualEffectView(effect: blur)
            blurredView.frame = self.view.frame
            self.view.backgroundColor = UIColor.clearColor()
            self.view.addSubview(blurredView)
        } else {
            self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        }
        self.view.alpha = 0
        
        if self.alertTitle == nil && self.message == nil {
            print("No text")
            self.alertTitle = " "
        }
        
        let tapBackToDismiss = self.tapBackgroundToDismiss ?? AOAlertSettings.sharedSettings.tapBackgroundToDismiss
        if self.actions.count == 0 || tapBackToDismiss {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(AOAlertController.didTapBackground(_:)))
//            let tapGest = UITapGestureRecognizer(target: self, action: "didTapBackground:")
            self.view.addGestureRecognizer(tapGest)
        }
        
        if self.actions.count > 1 {
            self.sortActions()
        }
        
        self.configureContainer()
    }
    
    
    @objc private func didTapBackground(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(self.view)
        if !CGRectContainsPoint(self.container.frame, location) {
            self.hideAndDismiss()
        }
    }
    
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showUp()
    }
    
    
    private func configureContainer() {
        let sharedSettings = AOAlertSettings.sharedSettings
        let titleFont  = self.titleFont ?? sharedSettings.titleFont
        let titleColor = self.titleColor ?? sharedSettings.titleColor
        let messageFont = self.messageFont ?? sharedSettings.messageFont
        let messageColor = self.messageColor ?? sharedSettings.messageColor
        let backColor = self.backgroundColor ?? sharedSettings.backgroundColor
        let linesColor = self.linesColor ?? sharedSettings.linesColor
        
        let containerWidth = self.style == .ActionSheet ? UIScreen.mainScreen().bounds.width - 2 * self.sheetHorizontalOffset : self.containerWidth
        
        // heights
        let titleHeight = self.prefferedLabelHeight(text: self.alertTitle, font: titleFont, width: containerWidth - 2 * self.contentOffset)
        let messageHeight = self.prefferedLabelHeight(text: self.message, font: messageFont, width: containerWidth - 2 * self.contentOffset)
        var textBoxHeight = (titleHeight == 0 ? self.contentOffset : titleHeight + 2 * self.contentOffset) + (messageHeight == 0 ? 0 : messageHeight + self.contentOffset)
        textBoxHeight += topAndBottomOffset * 2

        var sheetCancelActionHeight: CGFloat = 0
        
        var allHeight: CGFloat = 0
        switch self.style {
        case .ActionSheet:
            allHeight = textBoxHeight
            if let lastAction = self.actions.last {
                if lastAction.style == .Cancel {
                    allHeight += self.actionItemHeight * CGFloat(self.actions.count - 1)
                    sheetCancelActionHeight = self.actionItemHeight
                } else {
                    allHeight += self.actionItemHeight * CGFloat(self.actions.count)
                }
            }
        case .Alert:
            allHeight = textBoxHeight + (self.actions.count == 2 ? self.actionItemHeight : self.actionItemHeight * CGFloat(self.actions.count))
        }
        
        switch self.style {
        case .Alert:
            self.sheetYOffset = round((UIScreen.mainScreen().bounds.height - allHeight)/2)
        case .ActionSheet:
            self.sheetYOffset = UIScreen.mainScreen().bounds.height - (sheetCancelActionHeight == 0 ? self.sheetBottomOffset : self.sheetBottomOffset + self.sheetBetweenCancelOffset + sheetCancelActionHeight) - allHeight
        }
        
        //  white rounded rectangle
        let cFrame = CGRect(x: round((UIScreen.mainScreen().bounds.width - containerWidth)/2), y: self.sheetYOffset, width: containerWidth, height: allHeight)
        self.container = UIView(frame: cFrame)
        self.container.backgroundColor = backColor
        self.container.layer.cornerRadius = 11
        self.container.alpha = 0
        switch self.style {
        case .Alert:
            self.container.transform = CGAffineTransformMakeScale(0.5, 0.5)
        case .ActionSheet:
            var fr = cFrame
            fr.origin.y = UIScreen.mainScreen().bounds.height
            self.container.frame = fr
        }
        self.container.clipsToBounds = true
        self.view.addSubview(self.container)
        
        // cancel rounded rectangle
        if (self.style == .ActionSheet) && (sheetCancelActionHeight != 0) {
            let cancelFr = CGRect(x: cFrame.origin.x, y: UIScreen.mainScreen().bounds.height + self.sheetBottomOffset + cFrame.height, width: cFrame.width, height: sheetCancelActionHeight)
            let cancelCont = UIView(frame: cancelFr)
            cancelCont.backgroundColor = backColor
            cancelCont.layer.cornerRadius = 11
            cancelCont.alpha = 0
            cancelCont.clipsToBounds = true
            self.view.addSubview(cancelCont)
            self.cancelContainer = cancelCont
        }
        
        //  text box
        let titleYOffset = messageHeight == 0 ? (textBoxHeight - titleHeight)/2 : (textBoxHeight - titleHeight - messageHeight - self.contentOffset)/2
        let titleFrame = CGRect(x: self.contentOffset, y: titleYOffset, width: containerWidth - 2 * self.contentOffset, height: titleHeight)
        if let titleLabel = self.labelInFrame(titleFrame, text: self.alertTitle, font: titleFont, textColor: titleColor) {
            self.container.addSubview(titleLabel)
        }
        let messageYOffset = self.topAndBottomOffset
        let messageFrame = CGRect(x: self.alertMessageSideOffset, y: messageYOffset, width: containerWidth - 2 * self.alertMessageSideOffset, height: messageHeight)
        if let messageLabel = self.labelInFrame(messageFrame, text: self.message, font: messageFont, textColor: messageColor) {
            self.container.addSubview(messageLabel)
        }
        
        //  line under text box
        if self.actions.count > 0 {
            switch self.style {
            case .Alert:
                let hLine = UIView(frame: CGRect(x: 0, y: textBoxHeight, width: containerWidth, height: 0.5))
                hLine.backgroundColor = linesColor
                self.container.addSubview(hLine)
            case .ActionSheet:
                if self.actions.count == 1 {
                    if self.actions[0].style == .Cancel { break }
                }
                let hLine = UIView(frame: CGRect(x: 0, y: textBoxHeight, width: containerWidth, height: 0.5))
                hLine.backgroundColor = linesColor
                self.container.addSubview(hLine)
            }
        }
        
        //  actions lines
        switch self.style {
        case .Alert:
            //  vertival line
            if self.style == .Alert {
                if self.actions.count == 2 {
                    let vLine = UIView(frame: CGRect(x: containerWidth/2 - 0.5, y: textBoxHeight, width: 0.5, height: allHeight - textBoxHeight))
                    vLine.backgroundColor = linesColor
                    self.container.addSubview(vLine)
                    
                }
            }
            //  horizontal lines
            if self.actions.count > 2 {
                for i in 1..<self.actions.count {
                    let lFrame = CGRect(x: 0, y: textBoxHeight + CGFloat(i) * self.actionItemHeight, width: containerWidth, height: 0.5)
                    let line = UIView(frame: lFrame)
                    line.backgroundColor = linesColor
                    self.container.addSubview(line)
                }
            }
        case .ActionSheet:
            let count = self.actions.count - (sheetCancelActionHeight == 0 ? 0 : 1)
            if count > 1 {
                for i in 1..<count {
                    let lFrame = CGRect(x: 0, y: textBoxHeight + CGFloat(i) * self.actionItemHeight, width: containerWidth, height: 0.5)
                    let line = UIView(frame: lFrame)
                    line.backgroundColor = linesColor
                    self.container.addSubview(line)
                }
            }
        }
        
        //  actions
        switch self.style {
            
        case .Alert:
            if self.actions.count == 2 {
                for i in 0..<self.actions.count {
                    let actionFrame = CGRect(x: self.contentOffset + CGFloat(i) * containerWidth * 0.5, y: textBoxHeight + self.contentOffset, width: containerWidth * 0.5 - 2 * self.contentOffset, height: self.actionItemHeight - 2 * self.contentOffset)
                    let action = self.actions[i]
                    action.drawOnView(self.container, frame: actionFrame, completion: { [weak self] in
                        self?.hideAndDismiss()
                        })
                }
            } else {
                for i in 0..<self.actions.count {
                    let actionFrame = CGRect(x: self.contentOffset, y: textBoxHeight + CGFloat(i) * self.actionItemHeight + self.contentOffset, width: containerWidth - 2 * self.contentOffset, height: self.actionItemHeight - 2 * self.contentOffset)
                    let action = self.actions[i]
                    action.drawOnView(self.container, frame: actionFrame, completion: { [weak self] in
                        self?.hideAndDismiss()
                        })
                }
            }
            
        case .ActionSheet:
            if sheetCancelActionHeight == 0 {
                for i in 0..<self.actions.count {
                    let actionFrame = CGRect(x: self.contentOffset, y: textBoxHeight + CGFloat(i) * self.actionItemHeight + self.contentOffset, width: containerWidth - 2 * self.contentOffset, height: self.actionItemHeight - 2 * self.contentOffset)
                    let action = self.actions[i]
                    action.drawOnView(self.container, frame: actionFrame, completion: { [weak self] in
                        self?.hideAndDismiss()
                    })
                }
            } else {
                let count = self.actions.count - 1
                for i in 0..<count {
                    let actionFrame = CGRect(x: self.contentOffset, y: textBoxHeight + CGFloat(i) * self.actionItemHeight + self.contentOffset, width: containerWidth - 2 * self.contentOffset, height: self.actionItemHeight - 2 * self.contentOffset)
                    let action = self.actions[i]
                    action.drawOnView(self.container, frame: actionFrame, completion: { [weak self] in
                        self?.hideAndDismiss()
                        })
                }
                guard let cancelAction = self.actions.last else { break }
                guard let cancelContainer = self.cancelContainer else { break }
                let cancelFrame = CGRect(x: self.contentOffset, y: self.contentOffset, width: containerWidth - 2 * self.contentOffset, height: self.actionItemHeight - 2 * self.contentOffset)
                cancelAction.drawOnView(cancelContainer, frame: cancelFrame, completion: { [weak self] in
                    self?.hideAndDismiss()
                })
            }
        }
    }
    
    
    private func showUp() {
        var containerFr = self.container.frame
        containerFr.origin.y = self.sheetYOffset
        var cancelFr = self.cancelContainer?.frame
        cancelFr?.origin.y = self.sheetYOffset + containerFr.height + self.sheetBetweenCancelOffset
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { [weak self] in
            self?.view.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .CurveEaseInOut, animations: {
            self.container.alpha = 1
            switch self.style {
            case .Alert:
                self.container.transform = CGAffineTransformIdentity
            case .ActionSheet:
                self.cancelContainer?.alpha = 1
                self.container.frame = containerFr
                if let cancelFrame = cancelFr { self.cancelContainer?.frame = cancelFrame }
            }
            }, completion: nil)
    }
    
    
    private func hideAndDismiss() {
        var containerFr = self.container.frame
        containerFr.origin.y = UIScreen.mainScreen().bounds.height
        var cancelFr = self.cancelContainer?.frame
        cancelFr?.origin.y = containerFr.origin.y + containerFr.height + self.sheetBetweenCancelOffset
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .CurveEaseInOut, animations: {
            self.container.alpha = 0
            switch self.style {
            case .Alert:
                self.container.transform = CGAffineTransformMakeScale(0.5, 0.5)
            case .ActionSheet:
                self.cancelContainer?.alpha = 0
                self.container.frame = containerFr
                if let cancelFrame = cancelFr { self.cancelContainer?.frame = cancelFrame }
            }
            }, completion: nil)
        UIView.animateWithDuration(0.2, delay: 0.2, options: .CurveEaseInOut, animations: {
            self.view.alpha = 0
        }) { [weak self]_ in
                self?.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
    private func prefferedLabelHeight(text text: String?, font: UIFont?, width: CGFloat) -> CGFloat {
        guard let t = text else { return 0 }
        guard let f = font else { return 0 }
        if t.isEmpty { return 0 }
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = f
        label.text = t
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    private func labelInFrame(frame: CGRect, text: String?, font: UIFont?, textColor: UIColor) -> UILabel? {
        guard let f = font else { return nil }
        guard let t = text else { return nil }
        if frame.size.height == 0 { return nil }
        
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textColor = textColor
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = .Center
        label.font = f
        label.text = t
        return label
    }
    
    
    private func sortActions() {
        if self.actions.count < 2 { return }
        
        switch self.style {
        case .Alert:
            var cancelIndex: Int?
            for i in 0..<self.actions.count {
                if self.actions[i].style == .Cancel {
                    cancelIndex = i
                }
            }
            if let index = cancelIndex {
                let cancelAction = self.actions[index]
                if self.actions.count == 2 {
                    self.actions.removeAtIndex(index)
                    self.actions.insert(cancelAction, atIndex: 0)
                } else if self.actions.count > 2 {
                    self.actions.removeAtIndex(index)
                    self.actions.append(cancelAction)
                }
            }
            
        case .ActionSheet:
            var cancelIndex: Int?
            for i in 0..<self.actions.count {
                if self.actions[i].style == .Cancel {
                    cancelIndex = i
                }
            }
            if let index = cancelIndex {
                let cancelAction = self.actions[index]
                self.actions.removeAtIndex(index)
                self.actions.append(cancelAction)
            }
        }
    }
    
}
