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

var forceTouchAvailable:Bool {
	return UIView().traitCollection.forceTouchCapability == .Available
}

// At what level should the App switch to "Night" theme if "Auto Night Mode" is on.
let defaultAutoNightModeThreshold:Float = 0.2
// How often should the App check screen's brightness level to decide if should switch to "Night" theme.
let defaultAutoNightModeUpdateTimeInterval:NSTimeInterval = 5

let prosignContainerLeft = "["
let prosignContainerRight = "]"

// WPM
let outputMinWPM = 5
let outputMaxWPM = 50
let defaultOutputWPM = 20
let defaultInputWPM = 20

let supportedAudioDecoderWPMRange = 14...22
let supportedAudioDecoderPitchRange = 150...15000
let supportedOutputWPMRange = 5...50
let supportedOutputPitchRange = 150...15000

let inputPitchMin:Float = 1
let inputPitchMax:Float = 2000

// Audio
let defaultSampleRate:Float = 44100.0
let fttWindowSize:vDSP_Length = 4096
let audioSampleFrequencyTimeInterval:NSTimeInterval = 0
let defaultInputPitch:Float = 800
let defaultOutputPitch:Float = 800
let automaticPitchMin:Float = 500
var defaultInputPitchErrorRange:Float = 7
var inputPitchRange:Range<Int> {
	let settingsPitch = appDelegate.inputPitch
	return max(Int(inputPitchMin), Int(ceil(settingsPitch - defaultInputPitchErrorRange)))...max(Int(inputPitchMin), Int(defaultInputPitchErrorRange * 2), Int(ceil(settingsPitch + defaultInputPitchErrorRange)))
}
let printAudiWaveFormWhenDebug = false

// NSUserDefaultKeys
let userDefaultsKeyTheme = "Theme"
let userDefaultsKeyUserSelectedTheme = "Theme User Selected"
let userDefaultsKeyExtraTextWhenShare = "Extra Text When Share"
let userDefaultsKeyProsignTranslationType = "Prosign Translation Type"
let userDefaultsKeyNotFirstLaunch = "Not First Launch"
let userDefaultsKeyInteractionSoundDisabled = "Interaction Sound Disabled"
let userDefaultsKeyAnimationDurationScalar = "Animation Duration Scalar"
let userDefaultsKeyAppleLanguages = "AppleLanguages"
let userDefaultsKeyFirstLaunchLanguageCode = "First Launch Language Code"
let userDefaultsKeySoundOutputEnabled = "Sound Output Enableds"
let userDefaultsKeyFlashOutputEnabled = "Flash Output Enableds"
let userDefaultsKeyInputWPM = "Input WPM"
let userDefaultsKeyInputWPMAutomatic = "Input WPM Automatic"
let userDefaultsKeyOutputWPM = "Output WPM"
let userDefaultsKeyBrightenScreenWhenOutput = "Brighten Screen When Output"
let userDefaultsKeyInputPitch = "Input Pitch"
let userDefaultsKeyInputPitchAutomatic = "Input Pitch Not Automatic"
let userDefaultsKeyOutputPitch = "Output Pitch"
let userDefaultsKeyAutoCorrectMisSpelledWordsForAudioInput = "Auto Correct Mis-Spelled Words For Audio Input"
let userDefaultsKeyAutoNightMode = "Auto Night Mode"
let userDefaultsKeyAutoNightModeThreshold = "Auto Night Mode Threshold"
let userDefaultsKeyShowRestarAlert = "Show Restart Alert"

// Notification Names
let inputPitchDidChangeNotificationName = "Input Frequency Did Change Notification"
let inputWPMDidChangeNotificationName = "Input WPM Did Change Notification"
let themeDidChangeNotificationName = "Theme Did Change Notification"
let languageDidChangeNotificationName = "Language Did Change Notification"

let notRecognizedLetterStr = "🙁"

// Feedback Email
let feedbackEmailToRecipient = "MorseTransmitter@gmail.com"
let feedbackEmailMessageBody = ""

func getAttributedStringFrom(text:String?, withFontSize fontSize:CGFloat = UIFont.systemFontSize(), color:UIColor = UIColor.blackColor(), bold:Bool = false) -> NSMutableAttributedString? {
	return text == nil ? nil : NSMutableAttributedString(string: text!, attributes:
		[NSFontAttributeName: bold ? UIFont.boldSystemFontOfSize(fontSize) : UIFont.systemFontOfSize(fontSize),
			NSForegroundColorAttributeName: color])
}

