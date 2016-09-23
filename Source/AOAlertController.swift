//
//  AlertController.swift
//  CloudKeeper
//
//  Created by Олег Адамов on 08.04.16.
//  Copyright © 2016 AdamovOleg. All rights reserved.
//

import UIKit


open class AOAlertSettings {
    
    open static let sharedSettings = AOAlertSettings()
    
    open var titleFont              = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
    open var messageFont            = UIFont.systemFont(ofSize: 13)
    open var defaultActionFont      = UIFont.systemFont(ofSize: 16)
    open var cancelActionFont       = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
    open var destructiveActionFont  = UIFont.systemFont(ofSize: 16)
    
    open var backgroundColor        = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    open var linesColor             = UIColor(red: 0.8, green: 0.8, blue: 0.81, alpha: 1)
    open var titleColor             = UIColor.black
    open var messageColor           = UIColor.black
    open var defaultActionColor     = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    open var destructiveActionColor = UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1)
    open var cancelActionColor      = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    
    open var tapBackgroundToDismiss = false
}



public enum AOAlertActionStyle {
    case `default`, destructive, cancel
}


open class AOAlertAction {
    
    open var color: UIColor?
    open var font: UIFont?
    
    public init(title: String, style: AOAlertActionStyle, handler: (() -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    
    // MARK: - Private
    
    fileprivate let title: String
    fileprivate let style: AOAlertActionStyle
    fileprivate let handler: (() -> Void)?
    fileprivate var completion: (() -> Void)?
    
    fileprivate func drawOnView(_ parentView: UIView, frame: CGRect, completion: @escaping () -> Void) {
        let textFont  = self.font  ?? self.textFontByStyle()
        let textColor = self.color ?? self.textColorByStyle()
        
        let button = UIButton(frame: frame)
        button.titleLabel?.font = textFont
        button.setTitleColor(textColor, for: UIControlState())
        button.setTitle(self.title, for: UIControlState())
        button.addTarget(self, action: #selector(AOAlertAction.buttonPressed), for: .touchUpInside)
        self.completion = completion
        parentView.addSubview(button)
    }
    
    
    @objc fileprivate func buttonPressed() {
        self.handler?()
        self.completion?()
    }
    
    
    fileprivate func textColorByStyle() -> UIColor {
        switch self.style {
        case .cancel:      return AOAlertSettings.sharedSettings.cancelActionColor
        case .default:     return AOAlertSettings.sharedSettings.defaultActionColor
        case .destructive: return AOAlertSettings.sharedSettings.destructiveActionColor
        }
    }
    
    
    fileprivate func textFontByStyle() ->UIFont {
        switch  self.style {
        case .cancel:      return AOAlertSettings.sharedSettings.cancelActionFont
        case .default:     return AOAlertSettings.sharedSettings.defaultActionFont
        case .destructive: return AOAlertSettings.sharedSettings.destructiveActionFont
        }
    }
    
}



public enum AOAlertControllerStyle {
    case alert, actionSheet
}


open class AOAlertController: UIViewController {
    
    open var actionItemHeight: CGFloat = 44
    open var backgroundColor: UIColor?
    open var linesColor: UIColor?
    open var titleColor: UIColor?
    open var titleFont: UIFont? {
        didSet {
            if titleFont == nil { print("Error: title font is nil!") }
        }
    }
    open var messageColor: UIColor?
    open var messageFont: UIFont? {
        didSet {
            if messageFont == nil { print("Error: message font is nil!") }
        }
    }
    open var tapBackgroundToDismiss: Bool?
    
    
    public init(title: String?, message: String?, style: AOAlertControllerStyle) {
        self.alertTitle = title
        self.message = message
        self.style = style
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    open func addAction(_ action: AOAlertAction) {
        self.actions.append(action)
    }

    
    //MARK: - Private 
    
    fileprivate let style: AOAlertControllerStyle
    fileprivate var alertTitle: String?
    fileprivate let message: String?
    fileprivate let containerWidth: CGFloat = 270
    fileprivate let contentOffset: CGFloat = 4
    fileprivate let sheetHorizontalOffset: CGFloat = 10
    fileprivate let sheetBottomOffset: CGFloat = 9
    fileprivate var sheetYOffset: CGFloat = 0
    fileprivate let sheetBetweenCancelOffset: CGFloat = 8
    fileprivate let containerMinHeight: CGFloat = 60
    fileprivate var container = UIView()
    fileprivate var cancelContainer: UIView?
    fileprivate var actions = [AOAlertAction]()
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.alpha = 0
        
        if self.alertTitle == nil && self.message == nil {
            print("No text")
            self.alertTitle = " "
        }
        
        let tapBackToDismiss = self.tapBackgroundToDismiss ?? AOAlertSettings.sharedSettings.tapBackgroundToDismiss
        if self.actions.count == 0 || tapBackToDismiss {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(AOAlertController.didTapBackground(_:)))
            self.view.addGestureRecognizer(tapGest)
        }
        
        if self.actions.count > 1 {
            self.sortActions()
        }
        
        self.configureContainer()
    }
    
    
    @objc fileprivate func didTapBackground(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        if !self.container.frame.contains(location) {
            self.hideAndDismiss()
        }
    }
    
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showUp()
    }
    
    
    fileprivate func configureContainer() {
        let sharedSettings = AOAlertSettings.sharedSettings
        let titleFont  = self.titleFont ?? sharedSettings.titleFont
        let titleColor = self.titleColor ?? sharedSettings.titleColor
        let messageFont = self.messageFont ?? sharedSettings.messageFont
        let messageColor = self.messageColor ?? sharedSettings.messageColor
        let backColor = self.backgroundColor ?? sharedSettings.backgroundColor
        let linesColor = self.linesColor ?? sharedSettings.linesColor
        
        let containerWidth = self.style == .actionSheet ? UIScreen.main.bounds.width - 2 * self.sheetHorizontalOffset : self.containerWidth
        
        // heights
        let titleHeight = self.prefferedLabelHeight(text: self.alertTitle, font: titleFont, width: containerWidth - 2 * self.contentOffset)
        let messageHeight = self.prefferedLabelHeight(text: self.message, font: messageFont, width: containerWidth - 2 * self.contentOffset)
        var textBoxHeight = (titleHeight == 0 ? self.contentOffset : titleHeight + 2 * self.contentOffset) + (messageHeight == 0 ? 0 : messageHeight + self.contentOffset)
        if textBoxHeight < self.containerMinHeight { textBoxHeight = self.containerMinHeight }
        
        var sheetCancelActionHeight: CGFloat = 0
        
        var allHeight: CGFloat = 0
        switch self.style {
        case .actionSheet:
            allHeight = textBoxHeight
            if let lastAction = self.actions.last {
                if lastAction.style == .cancel {
                    allHeight += self.actionItemHeight * CGFloat(self.actions.count - 1)
                    sheetCancelActionHeight = self.actionItemHeight
                } else {
                    allHeight += self.actionItemHeight * CGFloat(self.actions.count)
                }
            }
        case .alert:
            allHeight = textBoxHeight + (self.actions.count == 2 ? self.actionItemHeight : self.actionItemHeight * CGFloat(self.actions.count))
        }
        
        switch self.style {
        case .alert:
            self.sheetYOffset = round((UIScreen.main.bounds.height - allHeight)/2)
        case .actionSheet:
            self.sheetYOffset = UIScreen.main.bounds.height - (sheetCancelActionHeight == 0 ? self.sheetBottomOffset : self.sheetBottomOffset + self.sheetBetweenCancelOffset + sheetCancelActionHeight) - allHeight
        }
        
        //  white rounded rectangle
        let cFrame = CGRect(x: round((UIScreen.main.bounds.width - containerWidth)/2), y: self.sheetYOffset, width: containerWidth, height: allHeight)
        self.container = UIView(frame: cFrame)
        self.container.backgroundColor = backColor
        self.container.layer.cornerRadius = 11
        self.container.alpha = 0
        switch self.style {
        case .alert:
            self.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        case .actionSheet:
            var fr = cFrame
            fr.origin.y = UIScreen.main.bounds.height
            self.container.frame = fr
        }
        self.container.clipsToBounds = true
        self.view.addSubview(self.container)
        
        // cancel rounded rectangle
        if (self.style == .actionSheet) && (sheetCancelActionHeight != 0) {
            let cancelFr = CGRect(x: cFrame.origin.x, y: UIScreen.main.bounds.height + self.sheetBottomOffset + cFrame.height, width: cFrame.width, height: sheetCancelActionHeight)
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
        
        let messageYOffset = titleHeight == 0 ? (textBoxHeight - messageHeight)/2 : (titleYOffset + titleHeight + self.contentOffset)
        let messageFrame = CGRect(x: self.contentOffset, y: messageYOffset, width: containerWidth - 2 * self.contentOffset, height: messageHeight)
        if let messageLabel = self.labelInFrame(messageFrame, text: self.message, font: messageFont, textColor: messageColor) {
            self.container.addSubview(messageLabel)
        }
        
        //  line under text box
        if self.actions.count > 0 {
            switch self.style {
            case .alert:
                let hLine = UIView(frame: CGRect(x: 0, y: textBoxHeight, width: containerWidth, height: 0.5))
                hLine.backgroundColor = linesColor
                self.container.addSubview(hLine)
            case .actionSheet:
                if self.actions.count == 1 {
                    if self.actions[0].style == .cancel { break }
                }
                let hLine = UIView(frame: CGRect(x: 0, y: textBoxHeight, width: containerWidth, height: 0.5))
                hLine.backgroundColor = linesColor
                self.container.addSubview(hLine)
            }
        }
        
        //  actions lines
        switch self.style {
        case .alert:
            //  vertival line
            if self.style == .alert {
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
        case .actionSheet:
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
            
        case .alert:
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
            
        case .actionSheet:
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
    
    
    fileprivate func showUp() {
        var containerFr = self.container.frame
        containerFr.origin.y = self.sheetYOffset
        var cancelFr = self.cancelContainer?.frame
        cancelFr?.origin.y = self.sheetYOffset + containerFr.height + self.sheetBetweenCancelOffset
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: { [weak self] in
            self?.view.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
            self.container.alpha = 1
            switch self.style {
            case .alert:
                self.container.transform = CGAffineTransform.identity
            case .actionSheet:
                self.cancelContainer?.alpha = 1
                self.container.frame = containerFr
                if let cancelFrame = cancelFr { self.cancelContainer?.frame = cancelFrame }
            }
            }, completion: nil)
    }
    
    
    fileprivate func hideAndDismiss() {
        var containerFr = self.container.frame
        containerFr.origin.y = UIScreen.main.bounds.height
        var cancelFr = self.cancelContainer?.frame
        cancelFr?.origin.y = containerFr.origin.y + containerFr.height + self.sheetBetweenCancelOffset
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
            self.container.alpha = 0
            switch self.style {
            case .alert:
                self.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .actionSheet:
                self.cancelContainer?.alpha = 0
                self.container.frame = containerFr
                if let cancelFrame = cancelFr { self.cancelContainer?.frame = cancelFrame }
            }
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions(), animations: {
            self.view.alpha = 0
        }) { [weak self]_ in
                self?.dismiss(animated: false, completion: nil)
        }
    }
    
    
    fileprivate func prefferedLabelHeight(text: String?, font: UIFont?, width: CGFloat) -> CGFloat {
        guard let t = text else { return 0 }
        guard let f = font else { return 0 }
        if t.isEmpty { return 0 }
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = f
        label.text = t
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    fileprivate func labelInFrame(_ frame: CGRect, text: String?, font: UIFont?, textColor: UIColor) -> UILabel? {
        guard let f = font else { return nil }
        guard let t = text else { return nil }
        if frame.size.height == 0 { return nil }
        
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textColor = textColor
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.font = f
        label.text = t
        return label
    }
    
    
    fileprivate func sortActions() {
        if self.actions.count < 2 { return }
        
        switch self.style {
        case .alert:
            var cancelIndex: Int?
            for i in 0..<self.actions.count {
                if self.actions[i].style == .cancel {
                    cancelIndex = i
                }
            }
            if let index = cancelIndex {
                let cancelAction = self.actions[index]
                if self.actions.count == 2 {
                    self.actions.remove(at: index)
                    self.actions.insert(cancelAction, at: 0)
                } else if self.actions.count > 2 {
                    self.actions.remove(at: index)
                    self.actions.append(cancelAction)
                }
            }
            
        case .actionSheet:
            var cancelIndex: Int?
            for i in 0..<self.actions.count {
                if self.actions[i].style == .cancel {
                    cancelIndex = i
                }
            }
            if let index = cancelIndex {
                let cancelAction = self.actions[index]
                self.actions.remove(at: index)
                self.actions.append(cancelAction)
            }
        }
    }
    
}
