//
//  General UI.swift
//  Morse
//
//  Created by Shuyang Sun on 12/14/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

let TAP_FEED_BACK_DURATION:NSTimeInterval = 0.4
let defaultAnimationDuration:NSTimeInterval = 0.5

let tableViewCellHeight:CGFloat = 50
let topBarHeight:CGFloat = 56

let cardViewTextFontSizeDictionary:CGFloat = 22
let cardViewMorseFontSizeDictionary:CGFloat = 16
let morseFontSizeProgressBar:CGFloat = 14

let cardViewLabelPaddingVerticle:CGFloat = 16
let cardViewLabelPaddingHorizontal:CGFloat = 15
let cardViewLabelVerticalGap:CGFloat = 10

let tableViewCellTrailingPadding:CGFloat = 20
var sliderWidth:CGFloat {
	return 200
}

let tableViewCellTextLabelFontSize:CGFloat = 16
let tableViewCellDetailTextLabelFontSize:CGFloat = 12

let appStoreURLString = "http://www.test.com"

private var cardViewHeight:CGFloat {
	//		return 74 // This is Google Translate card view's height
	return 86
}

var statusBarHeight:CGFloat {
	return UIApplication.sharedApplication().statusBarFrame.size.height
}

var animationDurationScalar:NSTimeInterval {
	return appDelegate.animationDurationScalar
}

enum Direction:Int {
	case Top = 1
	case Right = 2
	case Bottom = 3
	case Left = 4
}

