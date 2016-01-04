//
//  CardViewOutputTransitionInteractionController.swift
//  Morse
//
//  Created by Shuyang Sun on 12/19/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import UIKit

class CardViewOutputTransitionInteractionController: UIPercentDrivenInteractiveTransition {
	var transitionInProgress = false
	var outputVC:OutputViewController! = nil {
		willSet {
			let pinchGR = UIPinchGestureRecognizer(target: self, action: "handleInteractionGR:")
			let panGR = UIPanGestureRecognizer(target: self, action: "handleInteractionGR:")
			if newValue.pinchGR == nil {
				newValue.pinchGR = pinchGR
			}
			if newValue.panGR == nil {
				newValue.panGR = panGR
			}
		}
	}

	var tabBarVC:TabBarController! {
		return self.outputVC?.presentingViewController as? TabBarController
	}

	private var _shouldFinishTransition = false
	private var _panDistanceToDismiss:CGFloat {
		return self.tabBarVC.view.bounds.height/2.0
	}

	func handleInteractionGR(gr:UIGestureRecognizer) {
		if self.outputVC != nil && self.tabBarVC != nil {
			var ratio:CGFloat = 0
			var touchTranslation = CGPoint(x: 0, y: 0)
			if let panGR = gr as? UIPanGestureRecognizer {
				touchTranslation = panGR.translationInView(self.tabBarVC.view)
				ratio = min(1, max(0, touchTranslation.y - slideAndPinchStartDistance)/self._panDistanceToDismiss)
			} else if let pinchGR = gr as? UIPinchGestureRecognizer {
				ratio = max(0, 1 - pinchGR.scale)
			}
			let state = gr.state
			if state == .Began {
				self.tabBarVC.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
				self.transitionInProgress = true
			} else if state == .Changed && self.transitionInProgress {
				if (gr is UIPanGestureRecognizer) && touchTranslation.y >= slideAndPinchStartDistance || gr is UIPinchGestureRecognizer {
					self._shouldFinishTransition = ratio >= slideAndPinchRatioToDismiss
					if self.percentComplete != ratio {
						if ratio >= 1 {
							self.transitionInProgress = false
							finishInteractiveTransition()
						} else {
							updateInteractiveTransition(ratio)
						}
					}
				} else {
					// Commenting out this line because of a bug. cancelInteractiveTransition() not working
//					self._shouldFinishTransition = false
					self._shouldFinishTransition = true
				}
			} else if state == .Ended || state == .Cancelled && self.transitionInProgress {
				if !self._shouldFinishTransition
//					|| state == .Cancelled // Commenting out this line because of a bug. cancelInteractiveTransition() not working
				{
					// FIX ME: cancel is not working, there is a bug. The work around using now is to set dismissRatio to 0.
					cancelInteractiveTransition()
				} else {
					finishInteractiveTransition()
				}
				self.transitionInProgress = false
			}
		}
	}
}
