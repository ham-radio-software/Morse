//
//  General UI.swift
//  Morse
//
//  Created by Shuyang Sun on 11/30/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

var appDelegate:AppDelegate {
	return UIApplication.sharedApplication().delegate as! AppDelegate
}

var isPad:Bool {
	return UI_USER_INTERFACE_IDIOM() == .Pad
}

var isPhone:Bool {
	return UI_USER_INTERFACE_IDIOM() == .Phone
}

// WPM
let outputMinWPM = 5
let outputMaxWPM = 50

// Audio
let audioSampleFrequencyTimeInterval:NSTimeInterval = 0

// NSUserDefaultKeys
let userDefaultsKeyTheme = "Theme"
let userDefaultsKeyExtraTextWhenShare = "Extra Text When Share"
let userDefaultsKeyNotFirstLaunch = "Not First Launch"
let userDefaultsKeyInteractionSoundDisabled = "Interaction Sound Disabled"
let userDefaultsKeyAnimationDurationScalar = "Animation Duration Scalar"
let userDefaultsKeyAppleLanguages = "AppleLanguages"
let userDefaultsKeyFirstLaunchLanguageCode = "First Launch Language Code"
let userDefaultsKeySoundOutputEnabled = "Sound Output Enableds"
let userDefaultsKeyFlashOutputEnabled = "Flash Output Enableds"
let userDefaultsKeyInputWPM = "Input WPM"
let userDefaultsKeyOutputWPM = "Output WPM"
let userDefaultsKeyBrightenScreenWhenOutput = "Brighten Screen When Output"

let morseSoundStandardURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Morse Sound Standard", ofType: "aiff")!)
let notRecognizedLetterStr = "🙁"

func getAttributedStringFrom(text:String?, withFontSize fontSize:CGFloat = UIFont.systemFontSize(), color:UIColor = UIColor.blackColor(), bold:Bool = false) -> NSMutableAttributedString? {
	return text == nil ? nil : NSMutableAttributedString(string: text!, attributes:
		[NSFontAttributeName: bold ? UIFont.boldSystemFontOfSize(fontSize) : UIFont.systemFontOfSize(fontSize),
			NSForegroundColorAttributeName: color])
}

