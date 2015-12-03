//
//  MCHomeViewController.swift
//  Morse
//
//  Created by Shuyang Sun on 11/29/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import CoreData

class MCHomeViewController: UIViewController, UITextViewDelegate {

	// *****************************
	// MARK: Views
	// *****************************

	// Top bar views
	private var statusBarView:UIView!
	private var topBarView:UIView!

	// Text views
	private var hiddenLineView:UIView!
	private var textBackgroundView:UIView!
	private var inputTextView:UITextView!
	private var lineBreakView:UIView!
	private var outputTextView:UITextView!
	private var textBoxTapFeedBackView:UIView!

	// Button
	private var roundButton:MCRoundButtonView!

	// Scroll views
	private var scrollViewOverlay:UIButton!
	private var scrollView:UIScrollView!
	private var cardViews:[MCCardView] = []

	// *****************************
	// MARK: Private variables
	// *****************************

	private var isDirectionEncode:Bool = true
	private let coder = MorseCoder()

	private var interactionSoundEnabled:Bool {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return delegate.interactionSoundEnabled
	}

	// *****************************
	// MARK: UI Related Variables
	// *****************************
	private var viewWidth:CGFloat {
		return self.view.bounds.width
	}

	private var viewHeight:CGFloat {
		return self.view.bounds.height - self.tabBarHeight
	}

	private var tabBarHeight:CGFloat {
		if let tabBarController = self.tabBarController {
			return tabBarController.tabBar.bounds.height
		} else {
			return 0
		}
	}

	private var statusBarHeight:CGFloat {
		return UIApplication.sharedApplication().statusBarFrame.size.height
	}

	private let topBarHeight:CGFloat = 56

	private var animationDurationScalar:Double {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return delegate.animationDurationScalar
	}

	private var roundButtonRadius:CGFloat {
		if self.traitCollection.verticalSizeClass == .Regular &&
			self.traitCollection.horizontalSizeClass == .Regular {
			return 36
		} else {
			return 28
		}
	}

	private var theme:Theme {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		return delegate.theme
	}

	private var hintText:String {
		if self.isDirectionEncode {
			return "Encode text to Morse"
		} else {
			return "Decode Morse to Text"
		}
	}

	private var attributedHintText:NSMutableAttributedString {
		return NSMutableAttributedString(string: self.hintText, attributes:
			[NSFontAttributeName: UIFont.systemFontOfSize(16),
				NSForegroundColorAttributeName: UIColor(hex: 0x000, alpha: MDDarkTextHintAlpha)])
	}

	private var cardViewLeftMargin:CGFloat {
		if self.traitCollection.horizontalSizeClass == .Compact {
			return 16
		} else if self.traitCollection.horizontalSizeClass == .Regular {
			return 32
		}
		return 16
	}

	private var cardViewRightMargin:CGFloat {
		return self.cardViewLeftMargin
	}

	private var cardViewTopMargin:CGFloat {
		if self.traitCollection.verticalSizeClass == .Regular &&
			self.traitCollection.horizontalSizeClass == .Regular {
			return self.roundButtonRadius + 6
		} else {
			return self.roundButtonRadius + 3
		}
	}

	private var cardViewBottomMargin:CGFloat {
		return self.cardViewLeftMargin
	}

	private var cardViewGapY:CGFloat {
		if self.traitCollection.verticalSizeClass == .Regular &&
			self.traitCollection.horizontalSizeClass == .Regular {
			return 16
		} else {
			return 8
		}
	}

	private var cardViewHeight:CGFloat {
		return 74
	}

	private var roundButtonRightMargin:CGFloat {
		return self.cardViewRightMargin
	}

	private var textViewHeight:CGFloat {
		return 140
	}

	// *****************************
	// MARK: MVC Life Cycle
	// *****************************

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO: Custom tab bar item
		self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 0)
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if self.statusBarView == nil {
			self.statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.statusBarHeight))
			self.statusBarView.backgroundColor = self.theme.statusBarBackgroundColor
			self.view.addSubview(self.statusBarView)
			self.statusBarView.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.view)
				make.left.equalTo(self.view)
				make.right.equalTo(self.view)
				make.height.equalTo(self.statusBarHeight)
			})
		}

		if self.topBarView == nil {
			self.topBarView = UIView(frame: CGRect(x: 0, y: self.statusBarHeight, width: self.view.bounds.width, height: self.topBarHeight))
			self.topBarView.backgroundColor = self.theme.topBarBackgroundColor
			self.view.addSubview(topBarView)
			let topBarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.topBarView.bounds.width, height: self.topBarHeight))
			topBarLabel.textAlignment = .Center
			topBarLabel.tintColor = UIColor.whiteColor()
			topBarLabel.attributedText = NSAttributedString(string: "Morse Coder", attributes:
				[NSFontAttributeName: UIFont.boldSystemFontOfSize(23),
					NSForegroundColorAttributeName: UIColor.whiteColor()])
			self.topBarView.addSubview(topBarLabel)

			self.topBarView.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.view).offset(self.statusBarHeight)
				make.left.equalTo(self.view).offset(0)
				make.right.equalTo(self.view).offset(0)
				make.height.equalTo(self.topBarHeight)
			})
			topBarLabel.snp_makeConstraints(closure: { (make) -> Void in
				 make.edges.equalTo(self.topBarView)
			})
		}

		if self.textBackgroundView == nil {
			self.textBackgroundView = UIView(frame: CGRect(x: 0, y: self.topBarHeight + self.statusBarHeight, width: self.viewWidth, height: self.textViewHeight))
			self.textBackgroundView.backgroundColor = UIColor.whiteColor()
			self.textBackgroundView.layer.borderColor = UIColor.clearColor().CGColor
			self.textBackgroundView.layer.borderWidth = 0
			self.view.addSubview(self.textBackgroundView)

			// Configure contraints
			self.textBackgroundView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.topBarView.snp_bottom)
				make.right.equalTo(self.view)
				make.left.equalTo(self.view)
				make.height.equalTo(self.textViewHeight)
			}
		}

		if self.inputTextView == nil {
			self.inputTextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.textBackgroundView.bounds.width, height: self.textViewHeight/2.0))
			self.inputTextView.backgroundColor = UIColor.clearColor()
			self.inputTextView.opaque = false
			self.inputTextView.keyboardType = .ASCIICapable
			self.inputTextView.returnKeyType = .Done
			self.inputTextView.attributedText = self.attributedHintText
			self.inputTextView.delegate = self
			self.inputTextView.layer.borderColor = UIColor.clearColor().CGColor
			self.inputTextView.layer.borderWidth = 0
			self.textBackgroundView.addSubview(self.inputTextView)

			// Configure contraints
			self.inputTextView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.textBackgroundView)
				make.right.equalTo(self.textBackgroundView)
				make.left.equalTo(self.textBackgroundView)
				make.height.equalTo(self.textBackgroundView.snp_height).multipliedBy(0.5)
			}
		}

		if self.inputTextView.isFirstResponder() {
			self.textBackgroundView.addMDShadow(withDepth: 3)
		} else {
			self.textBackgroundView.addMDShadow(withDepth: 2)
		}

		if self.hiddenLineView == nil {
			self.hiddenLineView = UIView(frame: CGRect(x: 0, y: self.textViewHeight/2.0 + self.statusBarHeight + self.topBarHeight - self.textViewHeight, width: self.inputTextView.bounds.width, height: 1.0))
			if let color = self.inputTextView.backgroundColor {
				self.hiddenLineView.backgroundColor = color
			}
			self.hiddenLineView.layer.zPosition = CGFloat.max - 2
			self.textBackgroundView.addSubview(self.hiddenLineView)

			self.hiddenLineView.snp_remakeConstraints(closure: { (make) -> Void in
				make.left.equalTo(self.inputTextView)
				make.right.equalTo(self.inputTextView)
				make.bottom.equalTo(self.inputTextView)
				make.height.equalTo(self.textViewHeight)
			})
		}

		if self.outputTextView == nil {
			self.outputTextView = UITextView(frame: CGRect(x: 0, y: self.textViewHeight/2.0, width: self.viewWidth, height: self.textViewHeight/2.0))
			self.outputTextView.backgroundColor = UIColor.clearColor()
			self.outputTextView.opaque = false
			self.outputTextView.editable = false
			self.outputTextView.layer.borderColor = UIColor.clearColor().CGColor
			self.outputTextView.layer.borderWidth = 0
			// This gestureRecognizer is here to fix a bug where double tapping on outputTextView would resign inputTextView as first responder.
			let disableDoubleTapGR = UITapGestureRecognizer(target: nil, action: "")
			disableDoubleTapGR.numberOfTapsRequired = 2
			self.outputTextView.addGestureRecognizer(disableDoubleTapGR)
			self.textBackgroundView.insertSubview(self.outputTextView, belowSubview: self.hiddenLineView)

			// Configure contraints
			self.outputTextView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.inputTextView.snp_bottom)
				make.right.equalTo(self.textBackgroundView)
				make.bottom.equalTo(self.textBackgroundView)
				make.left.equalTo(self.textBackgroundView)
			}
		}

		self.outputTextView.bounds = CGRect(x: 0, y: 0, width: self.outputTextView.frame.width, height: self.outputTextView.frame.height)

		if self.textBoxTapFeedBackView == nil {
			self.textBoxTapFeedBackView = UIView(frame: CGRect(x: 0, y: 0, width: self.textBackgroundView.bounds.width, height: self.textBackgroundView.bounds.height))
			self.textBoxTapFeedBackView.backgroundColor = UIColor.clearColor()
			self.textBoxTapFeedBackView.layer.borderColor = UIColor.clearColor().CGColor
			self.textBoxTapFeedBackView.layer.borderWidth = 0
			self.textBoxTapFeedBackView.opaque = false
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTapped:")
			tapGestureRecognizer.cancelsTouchesInView = true
			self.textBoxTapFeedBackView.addGestureRecognizer(tapGestureRecognizer)
			self.textBackgroundView.addSubview(self.textBoxTapFeedBackView)

			self.textBoxTapFeedBackView.snp_makeConstraints(closure: { (make) -> Void in
				make.edges.equalTo(self.textBackgroundView)
			})
		}

		if self.roundButton == nil {
			self.roundButton = MCRoundButtonView(origin: CGPoint(x:self.view.bounds.width - self.roundButtonRightMargin - self.roundButtonRadius * 2, y:self.statusBarHeight + self.topBarHeight + self.textViewHeight - self.roundButtonRadius), radius: self.roundButtonRadius)
			self.view.addSubview(self.roundButton)
			self.roundButton.snp_makeConstraints(closure: { (make) -> Void in
				make.width.equalTo(self.roundButtonRadius * 2)
				make.height.equalTo(self.roundButton.snp_width)
				make.right.equalTo(self.view).offset(-self.roundButtonRightMargin)
				make.centerY.equalTo(self.textBackgroundView.snp_bottom)
			})
		}

		if self.scrollView == nil {
			self.scrollView = UIScrollView(frame: CGRect(x: 0, y: self.statusBarHeight + self.topBarHeight + self.textViewHeight, width: self.viewWidth, height: self.viewHeight - self.textViewHeight))
			self.scrollView.backgroundColor = UIColor.whiteColor()
			self.scrollView.userInteractionEnabled = true
			self.scrollView.bounces = true
			self.scrollView.showsHorizontalScrollIndicator = false
			self.scrollView.showsVerticalScrollIndicator = true
			self.view.insertSubview(self.scrollView, belowSubview: self.textBackgroundView)

			self.scrollView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.textBackgroundView.snp_bottom)
				make.right.equalTo(self.view)
				make.bottom.equalTo(self.view).offset(-self.tabBarHeight)
				make.left.equalTo(self.view)
			}
		}

		if self.scrollViewOverlay == nil {
			self.scrollViewOverlay = UIButton(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height))
			self.scrollViewOverlay.addTarget(self, action: "scrollViewOverlayTapped:", forControlEvents: .TouchUpInside)
			self.scrollViewOverlay.backgroundColor = UIColor(hex: 0x000, alpha: 0.35)
			self.scrollViewOverlay.opaque = false
			self.scrollViewOverlay.layer.borderColor = UIColor.clearColor().CGColor
			self.scrollViewOverlay.layer.borderWidth = 0
			self.scrollViewOverlay.hidden = true
			self.view.insertSubview(self.scrollViewOverlay, aboveSubview: self.scrollView)

			self.scrollViewOverlay.snp_makeConstraints(closure: { (make) -> Void in
				make.edges.equalTo(self.scrollView)
			})
		}

		self.updateCardViewsConstraints()
		self.view.layoutIfNeeded()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if self.scrollView.subviews.isEmpty {
			self.fetchCardsAndUpdateCardViews()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// *****************************
	// MARK: Text View Delegate
	// *****************************

	func textViewDidBeginEditing(textView: UITextView) {

		self.inputTextView.attributedText = getAttributedStringFrom(" ", withFontSize: 16, color: UIColor(hex: 0x000, alpha: MDDarkTextPrimaryAlpha))
		self.textBoxTapFeedBackView.hidden = true
		self.textBoxTapFeedBackView.userInteractionEnabled = false

		if self.lineBreakView == nil {
			self.lineBreakView = UIView(frame: CGRect(x: 0, y: self.textViewHeight, width: self.textBackgroundView.bounds.width, height: 1.0))
			self.lineBreakView.backgroundColor = UIColor(hex: 0x000, alpha: 0.1)
			self.lineBreakView.layer.zPosition = CGFloat.max - 1
			self.textBackgroundView.addSubview(self.lineBreakView)
		}

		self.lineBreakView.hidden = false
		self.lineBreakView.snp_remakeConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.textBackgroundView)
			make.right.equalTo(self.textBackgroundView)
			make.bottom.equalTo(self.inputTextView)
			make.height.equalTo(1.0)
		})

		UIView.animateWithDuration(0.15 * self.animationDurationScalar,
			delay: 0.0,
			options: .CurveLinear,
			animations: { () -> Void in
				self.view.layoutIfNeeded()
				self.scrollViewOverlay.hidden = false
		}, completion: nil)

		self.roundButton.disappearWithAnimationType([.Scale, .Fade], duration: TAP_FEED_BACK_DURATION/5.0)
	}

	func textViewDidChange(textView: UITextView) {
		self.coder.text = textView.text
		let outputText = self.coder.morse
		self.outputTextView.attributedText = getAttributedStringFrom(outputText, withFontSize: 16, color: UIColor(hex: 0x000, alpha: MDDarkTextPrimaryAlpha))
		if outputText != nil {
			self.outputTextView.scrollRangeToVisible(NSMakeRange(outputText!.startIndex.distanceTo(outputText!.endIndex), 0))
		}
	}

	func textViewDidEndEditing(textView: UITextView) {
		self.textBoxTapFeedBackView.hidden = false
		self.textBoxTapFeedBackView.userInteractionEnabled = true
		self.outputTextView.text = nil
		textView.attributedText = self.attributedHintText
		self.lineBreakView.snp_remakeConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.textBackgroundView)
			make.right.equalTo(self.textBackgroundView)
			make.bottom.equalTo(self.textBackgroundView)
			make.height.equalTo(1.0)
		})
		UIView.animateWithDuration(0.15 * self.animationDurationScalar,
			delay: 0.0,
			options: .CurveLinear,
			animations: { () -> Void in
				self.view.layoutIfNeeded()
				self.scrollViewOverlay.hidden = true
				self.textBackgroundView.addMDShadow(withDepth: 2)
			}) { (succeed) -> Void in
				if succeed {
					self.lineBreakView.hidden = true
				}
		}

		self.roundButton.appearWithAnimationType([.Scale, .Fade], duration: TAP_FEED_BACK_DURATION/5.0)
	}

	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			let text = self.isDirectionEncode ? self.inputTextView.text : self.outputTextView.text
			let morse = self.isDirectionEncode ? self.outputTextView.text : self.inputTextView.text
			if self.inputTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" || self.outputTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
				self.addCardViewWithText(text, morse: morse, textOnTop: self.isDirectionEncode, animateWithDuration: 0.3)
			}
			textView.resignFirstResponder()
		}
		return true
	}

	// *****************************
	// MARK: User Interaction Handler
	// *****************************

	// Gesture call backs.
	func textViewTapped(gestureRecognizer:UITapGestureRecognizer) {
		if self.interactionSoundEnabled {
			// TODO: Not working.
			if let path = NSBundle.mainBundle().pathForResource("Tock", ofType: "caf") {
				let tockURL = NSURL(fileURLWithPath: path)
				do {
					let audioPlayer = try AVAudioPlayer(contentsOfURL: tockURL)
					audioPlayer.play()
				} catch {
					NSLog("Tap feedback sound on text view play failed.")
				}
			} else {
				NSLog("Can't find \"Tock.caf\" file.")
			}
		}
		self.textBoxTapFeedBackView.hidden = true
		if !self.inputTextView.isFirstResponder() {
			self.inputTextView.becomeFirstResponder()
		}
		self.textBackgroundView.triggerTapFeedBack(atLocation: gestureRecognizer.locationInView(self.textBackgroundView), withColor: self.theme.textViewTapFeedbackColor, duration: TAP_FEED_BACK_DURATION * self.animationDurationScalar)
		self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 1), animated: true)
	}


	func scrollViewOverlayTapped(button:UIButton) {
		if self.inputTextView.isFirstResponder() {
			self.inputTextView.resignFirstResponder()
		}
	}

	// *****************************
	// MARK: Card View Manipulation
	// *****************************

	private func addCardViewWithText(text:String, morse:String, textOnTop:Bool = true, animateWithDuration duration:NSTimeInterval = 0.0) {
		let cardView = MCCardView(frame: CGRect(x: self.cardViewLeftMargin, y: self.cardViewTopMargin, width: self.scrollView.bounds.width - self.cardViewLeftMargin - self.cardViewRightMargin, height: self.cardViewHeight), text: text, morse: morse, textOnTop: textOnTop)
		// TODO: Animation
		cardView.opaque = false
		cardView.alpha = 0.0
		self.scrollView.addSubview(cardView)
		self.cardViews.append(cardView)
		self.updateCardViewsConstraints()
		self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 1), animated: true)
		UIView.animateWithDuration(duration / 3.0,
			delay: 0.0,
			options: .CurveEaseInOut,
			animations: { () -> Void in
				self.scrollView.layoutIfNeeded()
			}) { succeed in
				if succeed {
					UIView.animateWithDuration(duration * 2.0 / 3.0,
						delay: 0.0,
						options: .CurveEaseInOut,
						animations: { () -> Void in
							cardView.alpha = 1.0
						}) { succeed in
							if succeed {
								cardView.opaque = true
								self.saveCard(text, morse: morse, index: self.cardViews.count - 1, textOnTop: self.isDirectionEncode, favorite: false, deletable: true)
							}
					}
				}
		}
	}

	private func updateCardViewsConstraints() {
		var contentHeight = self.cardViewTopMargin + CGFloat(self.cardViews.count) * (self.cardViewHeight + self.cardViewGapY) + self.cardViewBottomMargin
		if !self.cardViews.isEmpty {
			contentHeight -= self.cardViewGapY
		}
		self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width, height: contentHeight)
		let views = self.cardViews
		for var i = views.count - 1; i >= 0; i-- {
			// TODO: If view is expanded (selected)
			if i >= views.count - 1 {
				views[i].snp_remakeConstraints(closure: { (make) -> Void in
					make.top.equalTo(self.cardViewTopMargin)
					make.left.equalTo(self.cardViewLeftMargin)
					make.width.equalTo(self.view.bounds.width - self.cardViewLeftMargin - self.cardViewRightMargin)
					make.height.equalTo(self.cardViewHeight)
				})
			} else {
				views[i].snp_remakeConstraints(closure: { (make) -> Void in
					make.top.equalTo(views[i + 1].snp_bottom).offset(self.cardViewGapY)
					make.left.equalTo(self.cardViewLeftMargin)
					make.width.equalTo(self.view.bounds.width - self.cardViewLeftMargin - self.cardViewRightMargin)
					make.height.equalTo(self.cardViewHeight)
				})
			}
			views[i].addMDShadow(withDepth: 1)
		}
	}

	// *****************************
	// MARK: Core Data
	// *****************************

	private func saveCard(text: String, morse:String, index:Int, textOnTop:Bool = true, favorite:Bool = false, deletable:Bool = true) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let entity = NSEntityDescription.entityForName("Card", inManagedObjectContext:managedContext)
		let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
		card.setValue(text, forKey: "text")
		card.setValue(morse, forKey: "morse")
		card.setValue(index, forKey: "index")
		card.setValue(textOnTop, forKey: "textOnTop")
		card.setValue(favorite, forKey: "favorite")
		card.setValue(deletable, forKey: "deletable")
		card.setValue(NSDate(), forKey: "dateCreated")

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}

	private func fetchCardsAndUpdateCardViews() {
		// If there is no card on the board, fetch some cards
		if self.cardViews.isEmpty {
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			let managedContext = appDelegate.managedObjectContext

			let fetchRequest = NSFetchRequest(entityName: "Card")
			let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
			fetchRequest.sortDescriptors = [sortDescriptor]

			do {
				let results = try managedContext.executeFetchRequest(fetchRequest)
				let cards = results as! [NSManagedObject]
				for card in cards {
					let cardView = MCCardView(frame: CGRect(x: self.cardViewLeftMargin, y: self.cardViewTopMargin, width: self.scrollView.bounds.width - self.cardViewLeftMargin - self.cardViewRightMargin, height: self.cardViewHeight), text: card.valueForKey("text") as? String, morse: card.valueForKey("morse") as? String, textOnTop: card.valueForKey("textOnTop") as! Bool)
					self.scrollView.addSubview(cardView)
					self.cardViews.append(cardView)
					self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: 1), animated: true)
					self.updateCardViewsConstraints()
					self.view.layoutIfNeeded()
				}
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
		}
	}
}
