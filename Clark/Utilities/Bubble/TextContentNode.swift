//
//  TextContentNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import NMessenger
import EZSwiftExtensions

extension TextContentNode {
    
    func configure(message: Message) {
        
        /// Fonts
        incomingTextFont = UIFont.defaultFont(size: 15)
        outgoingTextFont = UIFont.defaultFont(size: 15)
        
        /// Colors
        incomingTextColor = UIColor.messageIncomingColor
        outgoingTextColor = UIColor.white
        
        /// Attributes setup
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        
        var messageAttributedString = NSMutableAttributedString(string: message.body, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 15), NSParagraphStyleAttributeName: paragraph])
        
        if let absoluteString = message.htmlBody {
            
            messageAttributedString = NSMutableAttributedString(attributedString: absoluteString)
            messageAttributedString.addAttributes([NSFontAttributeName: UIFont.defaultFont(size: 15), NSParagraphStyleAttributeName: paragraph, NSKernAttributeName: 0.3, NSForegroundColorAttributeName: UIColor.trinidad], range: NSRange(location: 0, length: absoluteString.length))
            
            ez.runThisAfterDelay(seconds: 3, after: {
                self.textMessageNode.view.addTapGesture(action: { gesture in
                    if let url = message.htmlLink  {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    let params = ["link": message.htmlLink?.absoluteString ?? ""]
                    
                    /// Analytics 
                    if let _ = self.currentViewController as? HomeViewController {
                        Analytics.trackEventWithID(.s3_1, eventParams: params)
                    }
                    else {
                        Analytics.trackEventWithID(.s1_0, eventParams: params)
                    }
                })
            })
        }
        
        textMessageString = messageAttributedString
        
        backgroundColor = UIColor.clear
    }
}

