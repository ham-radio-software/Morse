//
//  CardView.swift
//  Morse
//
//  Created by Shuyang Sun on 11/30/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

class CardView: UIView {

	let paddingTop:CGFloat = 16
	let paddingLeading:CGFloat = 15
	let paddingTrailing:CGFloat = 15
	let paddingBottom:CGFloat = 16
	let gapY:CGFloat = 10

	var expanded = false

	// UI related variables
	private var _swipeBeganPosition:CGPoint!
	private var _distanceToDeleteCard:CGFloat {
		// How far the user needs to swipe to delete the card
		return min(360, self.bounds.width/2.0)
	}
	private var _swipeDirection:Direction = .Right
	private var _cardManipulation:CardManipulationType?
	private var _originalOrigin:CGPoint?

	// User setting related variables

	var text:String?
	var morse:String?
	var textOnTop = true
	var cardUniqueID:Int?
	var delegate:CardViewDelegate?
	var deletable:Bool = true
	private let _defaultMDShadowLevel:Int = 1

	// Subviews
	var topLabel:UILabel!
	var bottomLabel:UILabel!

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 2.0
		self.opaque = false
		self.backgroundColor = appDelegate.theme.cardViewBackgroudColor
		self.addMDShadow(withDepth: self._defaultMDShadowLevel)
		let tapGR = UITapGestureRecognizer(target: self, action: "tapped:")
		self.addGestureRecognizer(tapGR)
	}

	convenience init(frame:CGRect, text:String?, morse:String?, textOnTop:Bool = true, deletable:Bool = true) {
		self.init(frame:frame)
		self.text = text
		self.morse = morse
		self.textOnTop = textOnTop
		self.deletable = deletable

		self.topLabel = UILabel(frame: CGRect(x: self.paddingLeading, y: self.paddingTop, width: self.bounds.width - self.paddingLeading - self.paddingTrailing, height: (self.bounds.width - self.paddingTop - self.paddingBottom - self.gapY)/2.0))
		self.topLabel.opaque = false
		self.topLabel.backgroundColor = UIColor.clearColor()
		self.topLabel.layer.borderWidth = 0
		self.topLabel.layer.borderColor = UIColor.clearColor().CGColor
		self.topLabel.userInteractionEnabled = false
		if self.textOnTop {
			self.topLabel.attributedText = getAttributedStringFrom(self.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), withFontSize: 16, color: appDelegate.theme.cardViewTextColor, bold: true)
		} else {
			self.topLabel.attributedText = getAttributedStringFrom(self.morse, withFontSize: 14, color: appDelegate.theme.cardViewMorseColor)
			self.topLabel.lineBreakMode = .ByWordWrapping
		}
		self.addSubview(self.topLabel)

		self.topLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self).offset(self.paddingTop)
			make.trailing.equalTo(self).offset(-self.paddingTrailing)
			make.leading.equalTo(self).offset(self.paddingLeading)
			make.height.equalTo((self.bounds.height - self.paddingTop - self.paddingBottom - self.gapY)/2.0)
		}

		self.bottomLabel = UILabel(frame: CGRect(x: self.paddingLeading, y: self.paddingTop + self.topLabel.bounds.height + self.gapY, width: self.bounds.width - self.paddingLeading - self.paddingTrailing, height: (self.bounds.width - self.paddingTop - self.paddingBottom - self.gapY)/2.0))
		self.bottomLabel.opaque = false
		self.bottomLabel.backgroundColor = UIColor.clearColor()
		self.bottomLabel.layer.borderWidth = 0
		self.bottomLabel.layer.borderColor = UIColor.clearColor().CGColor
		self.bottomLabel.userInteractionEnabled = false
		if self.textOnTop {
			self.bottomLabel.attributedText = getAttributedStringFrom(self.morse, withFontSize: 14, color: appDelegate.theme.cardViewMorseColor)
			self.bottomLabel.lineBreakMode = .ByWordWrapping
		} else {
			// TODO: Capitalize each word at the beginning of the sentence?
			self.bottomLabel.attributedText = getAttributedStringFrom(self.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), withFontSize: 16, color: appDelegate.theme.cardViewTextColor, bold: true)
		}
		self.addSubview(bottomLabel)

		self.bottomLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.topLabel.snp_bottom).offset(self.gapY)
			make.trailing.equalTo(self).offset(-self.paddingTrailing)
			make.leading.equalTo(self).offset(self.paddingLeading)
			make.bottom.equalTo(self).offset(-self.paddingBottom)
		}
	}

	required init?(coder aCoder: NSCoder) {
		super.init(coder: aCoder)
	}

	// *****************************
	// MARK: User Interaction Handlers
	// *****************************

	func tapped(gestureRecognizer:UITapGestureRecognizer) {
		let location = gestureRecognizer.locationInView(self)
		if self.bounds.contains(location) {
			self.animateUserInteractionFeedbackAtLocation(location) {
				if let myDelegate = self.delegate {
					myDelegate.cardViewTapped(self)
				}
			}
		}
	}

	private func animateUserInteractionFeedbackAtLocation(location:CGPoint, completion:((Void) -> Void)? = nil) {
		let originalTransform = self.transform
		self.triggerTapFeedBack(atLocation: location, withColor: appDelegate.theme.cardViewTapfeedbackColor, duration: TAP_FEED_BACK_DURATION/2.0 * appDelegate.animationDurationScalar, showSurfaceReaction: true, completion: completion)
		UIView.animateWithDuration(TAP_FEED_BACK_DURATION/2.0 * appDelegate.animationDurationScalar,
			delay: 0.0,
			options: .CurveEaseIn,
			animations: {
				self.transform = CGAffineTransformScale(self.transform, 1.02, 1.02)
			}) { succeed in
				if succeed {
					UIView.animateWithDuration(TAP_FEED_BACK_DURATION/2.0 * appDelegate.animationDurationScalar,
						delay: 0.0,
						options: .CurveEaseOut,
						animations: {
							self.transform = originalTransform
					}, completion: nil)
				}
		}
	}

	// Do some initial setup when the user start touching this view.
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if self.deletable {
			self.delegate?.cardViewTouchesBegan(self, touches:touches, withEvent: event)
			if let touch = touches.first {
				self.updateSwipeDirection()
				self._swipeBeganPosition = touch.locationInView(self.superview!)
				self._originalOrigin = self.frame.origin
			}
		}
	}

	// Do some animation when the user is swipping the card.
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touchDirectionDecidingDistance:CGFloat = 10
		let touch = touches.first!
		let dtX = touch.locationInView(self.superview!).x - self._swipeBeganPosition.x
		let dtY = touch.locationInView(self.superview!).y - self._swipeBeganPosition.y
		// If the user is swipping left or right
		let scrollView = self.nextResponder() as? UIScrollView
		if self._cardManipulation != nil && abs(dtX)/abs(dtY) >= 2.0 {
			scrollView?.scrollEnabled = false
		} else {
			scrollView?.scrollEnabled = true
		}
		if !touches.isEmpty && self._swipeBeganPosition != nil {
			// User is trying to delete the card.
			if abs(dtX) > touchDirectionDecidingDistance &&
				(self._swipeDirection == .Right && dtX > 0 ||
				self._swipeDirection == .Left && dtX < 0) {
					if self._cardManipulation == nil {
						self._cardManipulation = .Delete
					}
			} else if abs(dtX) > touchDirectionDecidingDistance &&
				(self._swipeDirection == .Left && dtX > 0 ||
				self._swipeDirection == .Right && dtX < 0 ){
				if self._cardManipulation == nil {
					self._cardManipulation = .ShowActions
				}
			}
			if self._cardManipulation == .Delete && self.deletable &&
				(self._swipeDirection == .Right && dtX > 0 ||
				 self._swipeDirection == .Left && dtX < 0){
				let distanceToStartRotation:CGFloat = 15
				// Translate
				self.transform = CGAffineTransformMakeTranslation(dtX, 0)
				// Change alpha
				self.alpha = 1.0 - abs(dtX)/self.bounds.width
				// Rotate
				if abs(dtX) > distanceToStartRotation {
					var angle = CGFloat(Double((abs(dtX) - distanceToStartRotation)/(self._distanceToDeleteCard - distanceToStartRotation)) * M_PI_4)/2.0
					if self._swipeDirection == .Left {
						angle = -angle
					}
					self.transform = CGAffineTransformRotate(self.transform, angle)
				}
			} else if self._cardManipulation == .ShowActions {
				// TODO
			}
		}
	}

	// When user finish swipping the card, do something depends on the direction and distance of swipe.
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if self._cardManipulation == .Delete && self.deletable {
			let touch = touches.first!
			let dtX = touch.locationInView(self.superview!).x - self._swipeBeganPosition.x
			if abs(dtX) >= self._distanceToDeleteCard {
				// If swipped too far, delete card.
				UIView.animateWithDuration(TAP_FEED_BACK_DURATION * appDelegate.animationDurationScalar,
					delay: 0,
					options: .CurveLinear,
					animations: {
						self.alpha = 0
				}, completion: nil)
				self.delegate?.cardViewTouchesEnded(self, touches:touches, withEvent: event, deleteCard: true)
			} else {
				// If not far enough, restore cardView transform to identity
				UIView.animateWithDuration(TAP_FEED_BACK_DURATION/2.0 * appDelegate.animationDurationScalar,
					delay: 0,
					options: .CurveEaseOut,
					animations: {
						self.transform = CGAffineTransformIdentity
						self.alpha = 1
					}) { succeed in
						if succeed {
							self.delegate?.cardViewTouchesEnded(self, touches:touches, withEvent: event, deleteCard: false)
						}
				}
			}
		} else if self._cardManipulation == .ShowActions {
			// TODO
			self.delegate?.cardViewTouchesEnded(self, touches:touches, withEvent: event, deleteCard: false)
		}
		self._cardManipulation = nil
		let scrollView = self.nextResponder() as? UIScrollView
		scrollView?.scrollEnabled = true
	}

	// If the touch is canceled, always restore cardView and don't anything about the model.
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		if self._cardManipulation == .Delete && self.deletable {
			UIView.animateWithDuration(TAP_FEED_BACK_DURATION * appDelegate.animationDurationScalar,
				delay: 0,
				options: .CurveEaseOut,
				animations: {
					self.transform = CGAffineTransformIdentity
					self.alpha = 1
				}) { succeed in
					if succeed {
						self.delegate?.cardViewTouchesCancelled(self, touches:touches, withEvent: event)
					}
			}
		} else if self._cardManipulation == .ShowActions {
			// TODO
			self.delegate?.cardViewTouchesCancelled(self, touches:touches, withEvent: event)
		}
		self._cardManipulation = nil
		let scrollView = self.nextResponder() as? UIScrollView
		scrollView?.scrollEnabled = true
	}

	private func updateSwipeDirection() {
		// Find which direction we need to swipe first.
		let layoutDirection = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(.Unspecified)
		var result = Direction.Right
		if layoutDirection == .LeftToRight {
			result = .Right
		} else {
			result = .Left
		}
		// Switch swipe direction if the user want to swap button layout directions.
		if appDelegate.swapButtonLayout {
			result = Direction(rawValue: (result.rawValue + 2) % 4)!
		}
		self._swipeDirection = result
	}
}

enum CardManipulationType {
	case Delete
	case ShowActions
}
