//
//  Theme.swift
//  Morse
//
//  Created by Shuyang Sun on 11/29/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

enum Theme: String {
	case Default = "Default"

	// *****************************
	// MARK: Colors For UI
	// *****************************

	private var defaultTapFeedbackColorDark:UIColor {
		return UIColor(hex: 0x000000, alpha: 0.3)
	}

	private var defaultTapFeedbackColorLight:UIColor {
		return UIColor(hex: 0xFFFFFF, alpha: 0.3)
	}

	var statusBarBackgroundColor:UIColor {
		switch self {
		case .Default: return MDColorPalette.Indigo.P700
		}
	}

	var topBarBackgroundColor:UIColor {
		switch self {
		case .Default: return MDColorPalette.Indigo.P500
		}
	}

	var cancelButtonColor:UIColor {
		switch self {
		case .Default: return UIColor.whiteColor()
		}
	}

	var textViewBackgroundColor:UIColor {
		switch self {
		default: return UIColor.whiteColor()
		}
	}

	var textViewTapFeedbackColor:UIColor {
		switch self {
//		case .Default: return MDColorPalette.Indigo.P200
		default: return self.defaultTapFeedbackColorDark
		}
	}

	var roundButtonBackgroundColor:UIColor {
		switch self {
		case .Default: return MDColorPalette.Pink.A200!
		}
	}

	var roundButtonTapFeedbackColor:UIColor {
		switch self {
//		case .Default: return MDColorPalette.Pink.A400!
		default: return self.defaultTapFeedbackColorLight
		}
	}

	var keyboardButtonViewBackgroundColor:UIColor {
		switch self {
		default: return UIColor.whiteColor()
		}
	}

	var keyboardButtonViewTapFeedbackColor:UIColor {
		switch self {
		default: return self.defaultTapFeedbackColorDark
		}
	}

	var scrollViewBackgroundColor:UIColor {
		switch self {
		default: return UIColor.whiteColor()
		}
	}

	var scrollViewOverlayColor:UIColor {
		switch self {
		default: return UIColor(hex: 0x000, alpha: 0.35)
		}
	}

	var cardViewBackgroudColor:UIColor {
		switch self {
		case .Default: return MDColorPalette.Indigo.P400
		}
	}

	var cardViewTapfeedbackColor:UIColor {
		switch self {
//		case .Default: return MDColorPalette.Indigo.P500
		default: return UIColor(hex: 0xFFFFFF, alpha: 0.3)
		}
	}

	var cardViewTextColor:UIColor {
		switch self {
		default: return UIColor(hex: 0xFFFFFF, alpha: MDLightTextPrimaryAlpha)
		}
	}

	var cardViewMorseColor:UIColor {
		switch self {
		default: return UIColor(hex:0xFFFFFF, alpha: MDLightTextSecondaryAlpha)
		}
	}

	var tabBarBackgroundColor:UIColor {
		switch self {
		default: return UIColor.whiteColor()
		}
	}
}