//
//  AutocompleteCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class AutocompleteCollectionViewCell: UICollectionViewCell {
    
    /// Main label
    lazy var mainLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    /// Divider view
    lazy var dividerView: UIView = {
    
        let view = UIView()
        view.backgroundColor = UIColor.carara
        return view
    }()
    
    /// Configuration attributes
    let normalAttributes = [NSFontAttributeName: UIFont.defaultFont(),
                            NSForegroundColorAttributeName: UIColor.trinidad]
    let blueAttributes = [NSFontAttributeName: UIFont.defaultFont(),
                                       NSForegroundColorAttributeName: UIColor.dodgerBlue]
    let boldAttributes = [NSFontAttributeName: UIFont.defaultFont(style: .semiBold, size: 14),
                                       NSForegroundColorAttributeName: UIColor.trinidad]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Main label
        addSubview(mainLabel)
        
        /// Divider view
        addSubview(dividerView)
        
        /// Main label layout
        mainLabel.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.left.equalTo(15)
            maker.height.equalTo(self)
            maker.width.greaterThanOrEqualTo(25)
        }
        
        /// Divider view
        dividerView.snp.updateConstraints { maker in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(1)
            maker.bottom.equalTo(-1)
        }
    }
    
    fileprivate func attributedString(for string:AutoCompleteString, confirmed:String?, extra:String?) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString()
        
        // If a confirmed string exists, tack it on to before the value
        if let confirmed = confirmed, confirmed.characters.count > 0 {
            let confirmedString = NSAttributedString(string: confirmed + " " , attributes: boldAttributes)
            attributedString.append(confirmedString)
        }
        
        // If any extra text is leftover after the confirmation string, match the text with the value and bold any characters that match. If no extra exists, just add the value without any bolding.
        let extraAttributedString = NSMutableAttributedString(string: string.body, attributes: normalAttributes)
        if let extra = extra?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            var validRange:NSRange!
            
            // First loop through all the words and make sure if any specific words are being matched, they're prioritized. This is to make sure when searching names, sessions, etc, you can still search for a last name or a certain word in a jumble of other words and this will make sure only the correct instance of that letter will bold (i.e. when they're at the beginning of a word and not in the middle)
            let words = string.body.components(separatedBy: " ")
            var cummulativeLocation:Int = 0
            for word in words {
                let nsWord = word.lowercased() as NSString
                let wordRange = nsWord.range(of: extra)
                if wordRange.location == 0, wordRange.length > 0 {
                    validRange = NSMakeRange(cummulativeLocation, wordRange.length)
                    break
                }
                cummulativeLocation += word.characters.count + 1  // Add +1 for the spacing after
            }
            
            // If the word loop failed, just set the formatting to the whole string according to the length of "extra"
            if validRange == nil {
                validRange = NSRange(location:0, length:min(extra.characters.count, string.body.characters.count))  // We already know this string matches the beginning of the text, no need to match again. min check in place to gaurentee no crashing if extra is wrong
            }
            extraAttributedString.addAttributes(boldAttributes, range: validRange)
        }
        attributedString.append(extraAttributedString)
        
        // Add suffix if needed
        if let suffix = string.suffix {
            var suffixAttributedString = NSAttributedString(string: suffix, attributes: normalAttributes)
            if let entity = string.entitySuffix, entity {
                suffixAttributedString = NSAttributedString(string: suffix, attributes: blueAttributes)
            }
            attributedString.append(suffixAttributedString)
        }
        
        return attributedString
    }
    
    func configure(for category: AutocompleteCategory, extraString: String?) {
        
        let string = AutoCompleteString(body: category.body)
        mainLabel.attributedText = attributedString(for: string, confirmed: nil, extra:extraString)
    }
    
    func configure(for string: AutoCompleteString, confirmedString: String?, extraString: String?) {
        
        mainLabel.attributedText = attributedString(for: string, confirmed: confirmedString, extra:extraString)
    }
}
