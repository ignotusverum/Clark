//
//  String.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/19/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    var containsWhitespace : Bool {
        return(rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    var composedCount : Int {
        var count = 0
        enumerateSubstrings(in: startIndex..<endIndex, options: .byComposedCharacterSequences) {_ in count = count + 1}
        return count
    }
    
    var NoWhiteSpace : String {
        
        var string = self
        
        if string.contains(" "){
            
            string =  string.replacingOccurrences(of: " ", with: "")
        }
        
        return string
    }
    
    func rangesOfString(s: String) -> [Range<Index>] {
        do {
            let re = try NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: s), options: [.caseInsensitive])
            let range = nsRange(from: startIndex ..< endIndex)
            let matches = re.matches(in: self, options: [], range: range)
            return matches.flatMap({ self.range(from: $0.range) })
        } catch {
            return []
        }
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    
    func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" || trimmedString == "yes" || trimmedString == "no" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    func contains(_ find: String) -> Bool {
        
        return lowercased().range(of: find.lowercased()) != nil
    }
    
    func generateTitle(_ color: UIColor = UIColor.black, subtitle: String = "")-> NSAttributedString {
        
        let resultString = subtitle.length > 0 ? "\n" + subtitle : ""
        
        /// Title attributes
        let attributedString = NSMutableAttributedString.initWithString(self.uppercasedPrefix(1), lineSpacing: 5.0, aligntment: .center)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: length))
        
        /// Subtitle
        let textColor = UIColor.ColorWith(red: 113.0, green: 112.0, blue: 115.0, alpha: 1.0)
        
        let subtitleAttributedString = NSMutableAttributedString.initWithString(resultString.uppercased(), lineSpacing: 5.0, aligntment: .center)
        subtitleAttributedString.addAttributes([NSFontAttributeName: UIFont.defaultFont(size: 12), NSForegroundColorAttributeName: textColor], range: NSRange(location: 0, length: resultString.utf16.count))
        
        attributedString.append(subtitleAttributedString)
        
        return attributedString
    }
    
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, spacing: CGFloat = 0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle], context: nil)
        
        return boundingBox.height
    }
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func versionToInt() -> [Int] {
        return components(separatedBy: ".")
            .map {
                Int.init($0) ?? 0
        }
    }
    
    func setCharSpacing(_ spacing: Float)-> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: length))
        
        return attributedString
    }
    
    func with(lineSpacing: CGFloat, alignment: NSTextAlignment)-> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: self, lineSpacing: lineSpacing, alignment: alignment)
    }
}

extension NSAttributedString {
    
    func changeTextColor(_ color: UIColor)-> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(attributedString: self)
        
        attributedString.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSMutableAttributedString {
    
    func setColorForStr(_ textToFind: String, color: UIColor) {
        
        let range = mutableString.range(of: textToFind, options: .caseInsensitive);
        if range.location != NSNotFound {
            
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
    
    func setColorForRange(_ rangeToFind: NSRange, color: UIColor) {
        
        addAttribute(NSForegroundColorAttributeName, value: color, range: rangeToFind)
    }
    
    func setFontForStr(_ textToFind: String, font: UIFont) {
        
        let range = mutableString.range(of: textToFind, options: .caseInsensitive);
        if range.location != NSNotFound {
            addAttribute(NSFontAttributeName, value: font, range: range);
        }
    }
    
    static func initWithString(_ string: String, lineSpacing: CGFloat, aligntment: NSTextAlignment)-> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = aligntment
        
        let attrsDict : NSDictionary =  [NSParagraphStyleAttributeName : paragraphStyle]
        
        return NSMutableAttributedString(string: string, attributes: attrsDict as? [String : AnyObject])
    }
    
    convenience init(string: String?, lineSpacing: CGFloat, alignment: NSTextAlignment) {
        
        guard let string = string else {
            self.init(string: "")
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let attrsDict =  [NSParagraphStyleAttributeName : paragraphStyle]
        
        self.init(string: string, attributes: attrsDict)
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
