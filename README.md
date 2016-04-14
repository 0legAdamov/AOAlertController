# AOAlertController
[![Language](http://img.shields.io/badge/language-swift%202.2-brightgreen.svg?style=flat)]
(https://developer.apple.com/swift)
[![CocoaPods compatible](http://img.shields.io/cocoapods/v/AOIntroViewController.svg?style=flat)]
(https://cocoapods.org/pods/AOAlertController)
[![CocoaPods available](http://img.shields.io/badge/available-iOS%208.2-orange.svg)]
(https://developer.apple.com/swift)

`AOAlertController` looks like a usual `UIAlertController`, but each action item, titles, fonts and colors can be customized.

![Screenshot](demo.gif)

## Installation
- CocoaPods: `pod 'AOAlertController'`
- From Source folder

## Usage

#### There are two ways to set up Alerts:
- Configure `AOAlertSettings` class as default style for all alert controllers
- Set up each controller you want to create 

#### AOAlertSettings properties:
- `titleFont`
- `messageFont`
- `defaultActionFont`
- `cancelActionFont`
- `destructiveActionFont`
- `backgroundColor`
- `linesColor`
- `titleColor`
- `messageColor`
- `defaultActionColor`
- `destructiveActionColor`
- `cancelActionColor`
- `tapBackgroundToDismiss`

Example:
`AOAlertSettings.sharedSettings.backgroundColor = UIColor.redColor()` - this means that for all instances of the `AOAlertController` red background will be set as default.

#### Changing the properties of a single controller:
Properties set to individual controllers have a higher priority than properties from `AOAlertSettings`

#### Configuration
**Controller styles**
- `AOAlertControllerStyle.Alert`
- `AOAlertControllerStyle.ActionSheet`

**Available controller's properties**
- `actionItemHeight`
- `backgroundColor`
- `linesColor`
- `titleColor`
- `titleFont`
- `messageColor`
- `messageFont`
- `tapBackgroundToDismiss`

Example:
```Swift
let alert = AOAlertController(title: "Title", message: nil, style: .Alert)
alert.titleFont = UIFont(name: "AvenirNext-Bold", size: 14)!
```

**Action styles**
- `AOAlertActionStyle.Default`
- `AOAlertActionStyle.Cancel`
- `AOAlertActionStyle.Destructive`

**Available properties**
- `color`
- `font`

Example:
```Swift
let actionCancel = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
actionCancel.color = UIColor.orangeColor()
alert.addAction(actionCancel)
```

Full usage Example:
```Swift
let alert = AOAlertController(title: "Example Alert", message: "All in one", style: .Alert)
let action = AOAlertAction(title: "Default Action", style: .Default) {}
action.color = UIColor.blackColor()
let cancel = AOAlertAction(title: "Cancel", style: .Cancel, handler: nil)
alert.addAction(action)
alert.addAction(cancel)
self.navigationController?.presentViewController(alert, animated: false, completion: nil)
```
