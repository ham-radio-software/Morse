//
//  MTRoundButtonView.swift
//  Morse
//
//  Created by Shuyang Sun on 12/1/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

enum ButtonActionType {
	case Switch
}

class MTRoundButtonView: UIView {
	var buttonAction:ButtonActionType = .Switch

	private var theme:Theme {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return delegate.theme
	}

	private var shadowLevel:Int {
		return 3
	}

	private var animationDurationScalar:Double {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return delegate.animationDurationScalar
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	convenience init(origin:CGPoint, radius:CGFloat) {
		self.init(frame:CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2)))
		self.backgroundColor = self.theme.roundButtonBackgroundColor
		self.layer.cornerRadius = radius
		self.addMDShadow(withDepth: self.shadowLevel)
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}

	func disappearWithAnimationType(animationTypes:Set<AnimationType>, duration:NSTimeInterval) {
		// Define animation here according to animation types, call it later
		let animationClosure = {
			if animationTypes.contains(.Scale) {
				self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01)
			}
			if animationTypes.contains(.Fade) {
				self.alpha = 0.0
			}
			self.addMDShadow(withDepth: 0)
		}
		UIView.animateWithDuration(duration * self.animationDurationScalar,
			delay: 0.0,
			options: .CurveEaseInOut,
			animations: animationClosure) { succeed in
				if succeed {
					self.hidden = true
					self.userInteractionEnabled = false
				}
		}
	}

	func appearWithAnimationType(animationTypes:Set<AnimationType>, duration:NSTimeInterval) {
		// Unhide view first.
		self.hidden = false
		// Define animation here according to animation types, call it later
		let animationClosure = {
			if animationTypes.contains(.Scale) {
				self.transform = CGAffineTransformIdentity
			}
			if animationTypes.contains(.Fade) {
				self.alpha = 1
				self.userInteractionEnabled = true
			}
			self.addMDShadow(withDepth: self.shadowLevel)
		}
		UIView.animateWithDuration(duration * self.animationDurationScalar,
			delay: 0.0,
			options: .CurveEaseInOut,
			animations: animationClosure, completion: nil)
	}
}

enum AnimationType {
	case Scale
	case Fade
}

