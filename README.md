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
CocoaPods: 
`pod 'AOAlertController'`

## Usage

#### There are two ways to set up Alerts:
- Configure `AOAlertSettings` class as default style for all alert controllers
- Set up each controller you want to create 

#### AOAlertSettings properties:
- titleFont
- messageFont
- defaultActionFont
- cancelActionFont
- destructiveActionFont
- backgroundColor
- linesColor
- titleColor
- messageColor
- defaultActionColor
- destructiveActionColor
- cancelActionColor
- tapBackgroundToDismiss

Example:
`AOAlertSettings.sharedSettings.backgroundColor = UIColor.redColor()` - this means that for all instances of the controller red background will be set as default.

#### Changing the properties of a single controller
