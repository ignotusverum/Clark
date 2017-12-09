//
//  DefaultNotificationView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/25/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftMessages
import EZSwiftExtensions

class DefaultNotificationView: MessageView {
    
    /// Image
    var image: UIImage = UIImage() {
        didSet {
            
            /// Image view setup
            imageView?.image = image
        }
    }
    
    /// Image view
    @IBOutlet var imageView: UIImageView?

    /// Title
    var title: String = "" {
        didSet {
            
            let paragraph = NSMutableParagraphStyle()
            
            paragraph.lineSpacing = 7
            headerLabel?.attributedText = NSAttributedString(string: title, attributes: [NSParagraphStyleAttributeName: paragraph])
        }
    }
    
    /// Title lbael
    @IBOutlet var headerLabel: UILabel?
    
    // MARK: - Show notificaiton
    class func showNotification(controller: UIViewController, title: String, image: UIImage, inset: UIEdgeInsets = .zero) {
        
        let backgroundView: DefaultNotificationView = try! SwiftMessages.viewFromNib()
        backgroundView.title = title
        backgroundView.image = image
        
        backgroundView.clipsToBounds = true
        
        /// Message setup
        let messageView = MessageView(frame: .zero)
        messageView.layoutMargins = .zero
        messageView.installContentView(backgroundView, insets: inset)
        
        let bg = UIView()
        messageView.installBackgroundView(bg)
        
        messageView.configureDropShadow()
        messageView.safeAreaTopOffset = -6
        var config = SwiftMessages.defaultConfig
        
        config.presentationContext = .viewController(controller)
        
        ez.runThisAfterDelay(seconds: 0.3) {
            SwiftMessages.show(config: config, view: messageView)
        }
    }
}
