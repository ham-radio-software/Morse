//
//  MorseTransmitter.swift
//  Morse
//
//  Created by Shuyang Sun on 11/30/15.
//  Copyright © 2015 Shuyang Sun. All rights reserved.
//

import Foundation

class MorseTransmitter {
	private var _text:String?
	private var _morse:String?

	static let standardWordLength:Int = 50

	private let _getTimeStampQueue = dispatch_queue_create("Get Time Stamp Queue", nil)

	static let keys:[String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "à", "å", "ä", "ą", "æ", "ć", "ĉ", "ç", "đ", "ð", "é", "ę", "è", "ĝ", "ĥ", "ĵ", "ł", "ń", "ñ", "ó", "ö", "ø", "ś", "ŝ", "š", "þ", "ü", "ŭ", "ź", "ż", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", ",", "'", "\"", "_", ":", ";", "?", "!", "-", "+", "/", "(", ")", "&", "=", "@", "$"]

	static let encodeTextToMorseStringDictionary:Dictionary<String, String> = [
		// English Alphabets
		"a": "• —",
		"b": "— • • •",
		"c": "— • — •",
		"d": "— • •",
		"e": "•",
		"f": "• • — •",
		"g": "— — •",
		"h": "• • • •",
		"i": "• •",
		"j": "• — — —",
		"k": "— • —",
		"l": "• — • •",
		"m": "— —",
		"n": "— •",
		"o": "— — —",
		"p": "• — — •",
		"q": "— — • —",
		"r": "• — •",
		"s": "• • •",
		"t": "—",
		"u": "• • —",
		"v": "• • • —",
		"w": "• — —",
		"x": "— • • —",
		"y": "— • — —",
		"z": "— — • •",
		// Other Latin Alphabets (there are characters sharing one morese code here)
		"à": "• — — • —",
		"å": "• — — • —",
		"ä": "• — • —",
		"ą": "• — • —",
		"æ": "• — • —",
		"ć": "— • — • •",
		"ĉ": "— • — • •",
		"ç": "— • — • •",
		"đ": "• • — • •",
		"ð": "• • — — •",
		"é": "• • — • •",
		"ę": "• • — • •",
		"è": "• — • • —",
		"ĝ": "— — • — •",
		"ĥ": "— — — —",
		"ĵ": "• — — — •",
		"ł": "• — • • —",
		"ń": "— — • — —",
		"ñ": "— — • — —",
		"ó": "— — — •",
		"ö": "— — — •",
		"ø": "— — — •",
		"ś": "• • • — • • •",
		"ŝ": "• • • — •",
		"š": "— — — —",
		"þ": "• — — • •",
		"ü": "• • — —",
		"ŭ": "• • — —",
		"ź": "— — • • — •",
		"ż": "— — • • —",
		// Numbers
		"1": "• — — — —",
		"2": "• • — — —",
		"3": "• • • — —",
		"4": "• • • • —",
		"5": "• • • • •",
		"6": "— • • • •",
		"7": "— — • • •",
		"8": "— — — • •",
		"9": "— — — — •",
		"0": "— — — — —",
		// Special Characters
		".": "• — • — • —",
		",": "— — • • — —",
		"'": "• — — — — •",
		"\"": "• — • • — •",
		"_": "• • — — • —",
		":": "— — — • • •",
		";": "— • — • — •",
		"?": "• • — — • •",
		"!": "— • — • — —",
		"-": "— • • • • —",
		"+": "• — • — •",
		"/": "— • • — •",
		"(": "— • — — •",
		")": "— • — — • —",
		"&": "• — • • •",
		"=": "— • • • —",
		"@": "• — — • — •",
		"$": "• • • — • • —"
	]

	static let decodeMorseStringToTextDictionary:Dictionary<String, String> = [
		// English Alphabets
		"• —": "a",
		"— • • •": "b",
		"— • — •": "c",
		"— • •": "d",
		"•": "e",
		"• • — •": "f",
		"— — •": "g",
		"• • • •": "h",
		"• •": "i",
		"• — — —": "j",
		"— • —": "k",
		"• — • •": "l",
		"— —": "m",
		"— •": "n",
		"— — —": "o",
		"• — — •": "p",
		"— — • —": "q",
		"• — •": "r",
		"• • •": "s",
		"—": "t",
		"• • —": "u",
		"• • • —": "v",
		"• — —": "w",
		"— • • —": "x",
		"— • — —": "y",
		"— — • •": "z",
		// Other Latin Alphabets (there are characters sharing one morese code here)
		"• — — • —": "à",
		"• — • —": "æ",
		"— • — • •": "ć",
		"• • — — •": "ð",
		"• • — • •": "é",
		"• — • • —": "è",
		"— — • — •": "ĝ",
		"— — — —": "ĥ",
		"• — — — •": "ĵ",
		"— — • — —": "ń",
		"— — — •": "ø",
		"• • • — • • •": "ś",
		"• • • — •": "ŝ",
		"• — — • •": "þ",
		"• • — —": "ü",
		"— — • • — •": "ź",
		"— — • • —": "ż",
		// Numbers
		"• — — — —": "1",
		"• • — — —": "2",
		"• • • — —": "3",
		"• • • • —": "4",
		"• • • • •": "5",
		"— • • • •": "6",
		"— — • • •": "7",
		"— — — • •": "8",
		"— — — — •": "9",
		"— — — — —": "0",
		// Special Characters
		"• — • — • —": ".",
		"— — • • — —": ",",
		"• — — — — •": "'",
		 "• — • • — •": "\"",
		"• • — — • —": "_",
		"— — — • • •": ":",
		"— • — • — •": ";",
		"• • — — • •": "?",
		"— • — • — —": "!",
		"— • • • • —": "-",
		"• — • — •": "+",
		"— • • — •": "/",
		"— • — — •": "(",
		"— • — — • —": ")",
		"• — • • •": "&",
		"— • • • —": "=",
		"• — — • — •": "@",
		"• • • — • • —": "$"
	]

	var text:String? {
		set {
			self._text = newValue
			self._morse = nil
		}
		get {
			return self._text == nil ? decodeMorseToText(self._morse) : self._text
		}
	}

	var morse:String? {
		set {
			self._morse = newValue
			self._text = nil
		}
		get {
			return self._morse == nil ? encodeTextToMorse(self._text) : self._morse
		}
	}

	init() {

	}

	func morseRangeFromTextRange(range:NSRange) -> NSRange {
		if self.text != nil && self.morse != nil &&
			range.location > 0 && range.location + range.length <= self.text!.lengthOfBytesUsingEncoding(NSISOLatin1StringEncoding) {
			let textStr = self.text!

			let preText = textStr.substringWithRange(textStr.startIndex..<textStr.startIndex.advancedBy(range.location)) // ******TextSelected****** // This is the first "******" part.
			let postText = textStr.substringWithRange(textStr.startIndex..<textStr.startIndex.advancedBy(range.location + range.length)) // ******TextSelected****** // This is the "******TextSelected" part.
			let preMorse = encodeTextToMorse(preText)
			let endMorse = encodeTextToMorse(postText)
			let location = preMorse?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
			let end = endMorse?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
			if location != nil && end != nil {
				return NSRange(location: location!, length: end! - location!)
			}
		}

		let morseLen = self.morse?.lengthOfBytesUsingEncoding(NSISOLatin1StringEncoding)
		let defaultLocation = morseLen == nil ? 0 : morseLen!
		let defaultRange = NSRange(location: defaultLocation, length: 0)
		return defaultRange
	}

	// Assume morse is valid
	func getTimeStamp(withScalar scalar:Float = 1.0, delay:NSTimeInterval = 0.0) -> [NSTimeInterval]? {
		if self.morse == nil || self.morse!.isEmpty { return nil }
		if scalar <= 0 { return nil }
		if scalar <= 1.0/60 {
			NSLog("Input/output scalar(\(scalar)) is less than 1/60, may cause serious encoding or decoding problem.")
		}
		var res:[NSTimeInterval] = [delay]
		dispatch_sync(dispatch_queue_create("Get Time Stamp Queue", nil)) {
			// Seperate words
			let words = self.morse!.componentsSeparatedByString(WORD_GAP_STRING)
			var appendedWord = false
			for word in words {
				// Seperate letters
				let letters = word.componentsSeparatedByString(LETTER_GAP_STRING)
				var appendedLetter = false
				for letter in letters {
					// Seperate units
					let units = letter.componentsSeparatedByString(UNIT_GAP_STRING)
					var appendedUnit = false
					for unit in units {
						if unit == UNIT_DIT_STRING  {
							res.append(res.last! + NSTimeInterval(DIT_LENGTH * scalar))
							res.append(res.last! + NSTimeInterval(UNIT_GAP_LENGTH * scalar))
							appendedUnit = true
						} else if unit == UNIT_DAH_STRING {
							res.append(res.last! + NSTimeInterval(DAH_LENGTH * scalar))
							res.append(res.last! + NSTimeInterval(UNIT_GAP_LENGTH * scalar))
							appendedUnit = true
						}
					}
					if appendedUnit {
						res.removeLast()
						res.append(res.last! + NSTimeInterval(LETTER_GAP_LENGTH * scalar))
						appendedLetter = true
					}
				}
				if appendedLetter {
					res.removeLast()
					res.append(res.last! + NSTimeInterval(WORD_GAP_LENGTH * scalar))
					appendedWord = true
				}
			}
			if appendedWord {
				res.removeLast()
			}
		}
		return res.count == 1 ? nil : res
	}

	// Below are for audio input
	var delegate:MorseTransmitterDelegate?

	private let _audioAnalysisQueue = dispatch_queue_create("Audio Analysis Queue", nil)
	private var _currentLetterMorse = ""
	private var _inputWPM = 15
	private var _sampleRate:Double = -1
	private var _singalStarted = false
	private var _counter = 0
	// This variable means how many callbacks should one unit be with the given WPM and the default sample rate (44100).
	private var _unitLength:Float {
		let unitsPerSecond = Double(self._inputWPM) * 50.0 / 60.0
		return Float(self._sampleRate/1000.0/unitsPerSecond)
	}

	private var _oneUnitLengthRange:Range<Int> {
//		return	Int(floor(self._unitLength))...Int(floor(self._unitLength * 2))
		return 3...5
	}

	private var _threeUnitLengthRange:Range<Int> {
//		return	self._oneUnitLengthRange.endIndex...self._oneUnitLengthRange.startIndex * 3
		return 7...14
	}

	private var _sevenUnitLengthRange:Range<Int> {
//		return	self._threeUnitLengthRange.endIndex...self._oneUnitLengthRange.startIndex * 99
		return 15...23
	}

	private var _isDuringSignal = false
	private var _levelsRecord:[Float] = []
	private var _minLvl = Int.max

	func resetForAudioInput() {
		self._morse = ""
		self._text = ""
		self._currentLetterMorse = ""
		self._inputWPM = 15
		self._sampleRate = -1
	}

	func microphone(microphone: EZMicrophone!,
		hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>,
		withBufferSize bufferSize: UInt32,
		withNumberOfChannels numberOfChannels: UInt32) {
		dispatch_sync(self._audioAnalysisQueue) {
			// Setup sample rate
			if self._sampleRate < 0 {
				self._sampleRate = microphone.audioStreamBasicDescription().mSampleRate
				print(self._unitLength)
				print(self._oneUnitLengthRange)
				print(self._threeUnitLengthRange)
				print(self._sevenUnitLengthRange)
			}
			// Setup WPM
			self._inputWPM = 15 // TODO: Better algorithm for this

			// Calculate the root mean square (which was just appended to the plot buffer)
			let rms = EZAudioUtilities.RMS(buffer.memory, length: Int32(bufferSize))
			let level = pow(rms * 100, 1.5)

			// If debugging, print the wave form in the console.
			#if DEBUG
			for _ in 0...Int(level) {
				print("=", separator: "", terminator: "")
			}
			print("\(Int(level))", separator: "", terminator: "")
			print("")
			#endif

			// TODO: Is during signal
			self._levelsRecord.append(level)
			let recordLength = (self._oneUnitLengthRange.startIndex + self._oneUnitLengthRange.endIndex - 1)/2
			while self._levelsRecord.count > recordLength {
				self._levelsRecord.removeFirst()
			}
			let avgLvl = (self._levelsRecord.reduce(0) { return $0 + $1 }) / Float(recordLength)
			self._isDuringSignal = level > max(avgLvl/3.0, 1)

			if self._isDuringSignal {
				if self._singalStarted {
					self._counter++
				} else {
					// If this is where the singal rises
					if !self._text!.isEmpty {
						if self._threeUnitLengthRange.contains(self._counter) {
							self.appendUnit(.LetterGap)
						} else if self._sevenUnitLengthRange.contains(self._counter) {
							self.appendUnit(.WordGap)
						}
					}
					self._counter = 0
				}
				self._singalStarted = true
			} else {
				if self._singalStarted {
					// If this is where the singal falls
					if self._oneUnitLengthRange.contains(self._counter) {
						self.appendUnit(.Dit)
					} else if self._threeUnitLengthRange.contains(self._counter) || self._sevenUnitLengthRange.contains(self._counter) {
						self.appendUnit(.Dah)
					}
					self._counter = 0
				} else {
					self._counter++
				}
				self._singalStarted = false
			}
		}
	}

	private func appendUnit(unit:MorseUnit) {
		if unit == .LetterGap || unit == .WordGap {
			// If we're appending a gap, reset currentLetterMorse
			self._currentLetterMorse = ""
			self._morse?.appendContentsOf(unit.rawValue)
			if unit == .WordGap {
				self._text?.appendContentsOf(" ")
			}
		} else {
			let startOfALetter = self._currentLetterMorse.isEmpty
			// We're sure unit is either DIT or DAH at this point
			if !self._currentLetterMorse.isEmpty && !self._currentLetterMorse.hasPrefix(" ") {
				self._currentLetterMorse.appendContentsOf(" ")
				self._morse?.appendContentsOf(" ")
			}
			self._currentLetterMorse.appendContentsOf(unit.rawValue)
			self._morse?.appendContentsOf(unit.rawValue)

			// Change text
			var letter = MorseTransmitter.decodeMorseStringToTextDictionary[self._currentLetterMorse]
			if letter == nil {
				letter = notRecognizedLetterStr
			}
			if !startOfALetter {
				self._text?.removeAtIndex(self._text!.endIndex.advancedBy(-1))
			}
			self._text?.appendContentsOf(letter!)
		}
		self.delegate?.transmitterContentDidChange?(self._text!, morse: self._morse!)
	}
}

enum MorseUnit:String {
	case Dit = "•"
	case Dah = "—"
	case LetterGap = "   "
	case WordGap = "       "
}

private let _encodeQueue = dispatch_queue_create("Encode Queue", nil)
private let _decodeQueue = dispatch_queue_create("Decode Queue", nil)

// Ignores invalid character
private func encodeTextToMorse(text:String!) -> String? {
	if text == nil || text.isEmpty { return nil }
	var res = ""
	dispatch_sync(_encodeQueue) {
		let words = text.lowercaseString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " \t\n\r"))
		for word in words {
			let chArr = word.characters
			var wordStr:String = ""
			for ch in chArr {
				if let chMorseString = MorseTransmitter.encodeTextToMorseStringDictionary[String(ch)] {
					wordStr += chMorseString
					wordStr += LETTER_GAP_STRING
				}
			}

			if !wordStr.isEmpty {
				res += wordStr
				// 4 spaces, on top of the last 3, make it 7
				res += "    "
			}
		}
		if !res.isEmpty {
			res.removeRange(res.endIndex.advancedBy(-7)..<res.endIndex)
		}
	}
	return res.isEmpty ? nil : res
}

// Assume morse is valid
private func decodeMorseToText(morse:String!) -> String? {
	if morse == nil || morse.isEmpty { return nil }
	var res = ""
	dispatch_sync(_decodeQueue) {
		let words = morse.componentsSeparatedByString(WORD_GAP_STRING)
		for word in words {
			let chArr = word.componentsSeparatedByString(LETTER_GAP_STRING)
			var wordStr:String = ""
			for ch in chArr {
				if let chText = MorseTransmitter.decodeMorseStringToTextDictionary[String(ch)] {
					wordStr += chText
				} else {
					wordStr += notRecognizedLetterStr
				}
			}

			if !wordStr.isEmpty {
				res += wordStr
				res += " "
			}
		}
		if !res.isEmpty {
			res.removeAtIndex(res.endIndex.advancedBy(-1))
		}
	}
	return res.isEmpty ? nil : res
}

private let WORD_GAP_STRING = MorseUnit.WordGap.rawValue
private let LETTER_GAP_STRING = MorseUnit.LetterGap.rawValue
private let UNIT_GAP_STRING = " "
private let UNIT_DIT_STRING = MorseUnit.Dit.rawValue
private let UNIT_DAH_STRING = MorseUnit.Dah.rawValue
private let DIT_LENGTH:Float = 1.0
private let UNIT_GAP_LENGTH:Float = 1.0
private let DAH_LENGTH:Float = 3.0
private let LETTER_GAP_LENGTH:Float = 3.0
private let WORD_GAP_LENGTH:Float = 7.0

