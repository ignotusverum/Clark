//
//  ChatViewBanner.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SwiftOnoneSupport

let setCollectionViewInsets = Notification.Name("setCollectionViewInsets")

public enum BannerType {
    case clarkOffline
    case userDisconnected
    case error(String)
}

extension BannerType: Equatable {}
public func ==(lhs: BannerType, rhs: BannerType) -> Bool {
    switch (lhs, rhs) {
    case (.clarkOffline, .clarkOffline), (.userDisconnected, .userDisconnected):
        return true
    case (.error(let string1), .error(let string2)):
        return string1 == string2
    default:
        return false
    }
}

public class ChatViewBanner: UIToolbar {
    
    // MARK: - Properties
    public static var hideCallback: ((BannerType?) -> Void)?
    
    public private(set) var isAnimating: Bool = false
    public private(set) var isDragging: Bool = false
    public private(set) var showSecondTextField: Bool = false
    public var isShowing:Bool {
        if let top = showConstraint?.constant {
            return top == UIApplication.shared.statusBarFrame.size.height + self.navigationBarHeight
        }
        return false
    }
    public private(set) var type:BannerType?
    
    // Constants
    static let bannerExhibitionDuration: TimeInterval = 5.0 // second(s)
    static let bannerIconSize = CGSize(width: 22, height: 22)
    private let idealBannerHeight: CGFloat = 64.0
    private let minYSpacing: CGFloat = 9.0
    public private(set) var actualBannerHeight: CGFloat = 64.0 {
        didSet {
            heightConstraint?.constant = actualBannerHeight
        }
    }
    
    // Spacing properties
    static var bannerLabelTitleHeight: CGFloat = 26
    static var bannerLabelMessageHeight: CGFloat = 35
    var navigationBarHeight: CGFloat = 44
    
    // Editable Constraints
    weak var showConstraint:NSLayoutConstraint?
    weak var heightConstraint:NSLayoutConstraint?
    
    
    // MARK: - Computed properties
    
    /// Views
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var xImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "x_shape")
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        titleLabel.textColor = UIColor.darkText
        return titleLabel
        }()
    
    //todo - remove or rebuild subtitle, dragview + handling
    
    fileprivate lazy var subtitleLabel: UILabel = { [unowned self] in
        let subtitleLabel = UILabel()
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 2
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
        subtitleLabel.textColor = UIColor.darkText
        return subtitleLabel
        }()
    
    fileprivate lazy var dragView: UIView = { [unowned self] in
        let dragView = UIView()
        dragView.backgroundColor = UIColor(white: 1.0, alpha: 0)
        dragView.layer.cornerRadius = 3 / 2
        return dragView
        }()
    
    
    /// Frames
    
    open var  iconSize: CGSize = CGSize(width: 22, height: 22) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    fileprivate var imageViewFrame: CGRect {
        return CGRect(x: 16.0, y: (actualBannerHeight/2)-(iconSize.height/2), width: iconSize.width, height: iconSize.height)
    }
    
    fileprivate var xImageViewFrame: CGRect {
        return CGRect(x: UIScreen.main.bounds.size.width-10-16, y: (actualBannerHeight/2)-(10/2), width: 10, height: 10)
    }
    
    fileprivate var dragViewFrame: CGRect {
        let width: CGFloat = 40
        return CGRect(x: (UIScreen.main.bounds.size.width - width) / 2 ,
                      y: UIApplication.shared.statusBarFrame.size.height + navigationBarHeight + actualBannerHeight - 5,
                      width: width,
                      height: 3)
    }
    
    fileprivate var backgroundView = UIView()
    
    fileprivate var textPointX: CGFloat {
        if imageView.image == nil {
            let xAmount = UIScreen.main.bounds.size.width - (xImageViewFrame.minX - 14) // 14 is spacing between x and text
            return xAmount
        }
        return  16 + iconSize.width + 16
    }
    
    /// The origin of the text
    fileprivate var titleLabelFrame: CGRect {
        let xAmount = UIScreen.main.bounds.size.width - (xImageViewFrame.minX - 14) // 14 is spacing between x and text
        let width = UIScreen.main.bounds.size.width - self.textPointX - xAmount
        let size = self.titleLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let y = (((actualBannerHeight/2) - (size.height/2)))
        return CGRect(x: textPointX, y: y, width: width, height: size.height)
    }
    
    fileprivate var messageLabelFrame: CGRect {
        let y: CGFloat = 25
        let xAmount = UIScreen.main.bounds.size.width - (xImageViewFrame.minX - 14) // 14 is spacing between x and text
        if (self.imageView.image == nil) && !self.showSecondTextField {
            let x: CGFloat = 5
            return CGRect(x: x, y: y, width: UIScreen.main.bounds.size.width - x - xAmount, height: 35)
        } else if (self.imageView.image == nil){
            return CGRect(x: 0, y: 0, width:0, height:0)
        }
        return CGRect(x: textPointX, y: y, width: UIScreen.main.bounds.size.width - textPointX - xAmount, height: 35)
    }
    
    // MARK: - Override Toolbar
    
    open override var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: actualBannerHeight)
    }
    
    
    // MARK: - Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: actualBannerHeight))
        
        startNotificationObservers()
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Observers
    
    fileprivate func startNotificationObservers() {
        /// Enable orientation tracking
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
        /// Add Orientation notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewBanner.orientationStatusDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    
    // MARK: - Orientation Observer
    
    @objc fileprivate func orientationStatusDidChange(_ notification: Foundation.Notification) {
        updateUI()
    }
    
    
    // MARK: - Setups
    
    
    
    fileprivate func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // Bar style
        self.isTranslucent = false
        self.barStyle = UIBarStyle.default
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
        
        // Add subviews
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.imageView)
        //self.addSubview(self.dragView)
        self.addSubview(self.xImageView)
        
        // Gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewBanner.didTap(_:)))
        self.addGestureRecognizer(tap)
        // Gesture for drag-to-hide
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ChatViewBanner.didPan(_:)))
        self.addGestureRecognizer(pan)
        
        // Setup frames
        updateUI()
    }
    
    func updateUI() {
        // update frames
        if !isAnimating { // dont update when animating
            // If self has been added to the superview already but the constraints havent been set up yet, add all constraints
            if let superview = superview, showConstraint == nil || heightConstraint == nil {
                superview.removeConstraints(self.constraints)  // Make sure we're not duplicating constraints
                self.removeConstraints(self.constraints)  // Remove height constraint
                self.translatesAutoresizingMaskIntoConstraints = false
                let topConstant = UIApplication.shared.statusBarFrame.size.height + self.navigationBarHeight - actualBannerHeight
                let topConstraint = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: topConstant)
                let heightConstraint = self.heightAnchor.constraint(equalToConstant: actualBannerHeight)
                self.showConstraint = topConstraint
                self.heightConstraint = heightConstraint
                NSLayoutConstraint.activate([
                    topConstraint,
                    self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                    self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    heightConstraint])
                
                // Set up banner height. Needs to happen here so that the height constraint will be valid on first load
                let minBannerHeight = minYSpacing * 2.0 + titleLabelFrame.height
                actualBannerHeight = max(idealBannerHeight, minBannerHeight)
                
                // Initiate constraints to make sure frames are being calculated correctly below
                superview.layoutIfNeeded()
            }
            
            let minBannerHeight = minYSpacing * 2.0 + titleLabelFrame.height
            actualBannerHeight = max(idealBannerHeight, minBannerHeight)
            
            self.titleLabel.frame = self.titleLabelFrame
            self.imageView.frame = self.imageViewFrame
            self.subtitleLabel.frame = self.messageLabelFrame
            self.dragView.frame = self.dragViewFrame
            self.xImageView.frame = self.xImageViewFrame
        }
    }
    
    fileprivate func showAnimated() {
        isAnimating = true
        showConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + self.navigationBarHeight
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.superview?.layoutIfNeeded()
            
            // Send the banner height to the chat view controller so it can set up its insets correctly
            let userInfo = ["bannerHeight":self.actualBannerHeight]
            NotificationCenter.default.post(name: setCollectionViewInsets, object: nil, userInfo: userInfo)
        }) { (finished) in
            self.isAnimating = false
            // Check if the banner was requested to hide while it was animating to be shown. If so, hide it now.
            if let hideInfo = self.hideOnComplete {
                self.hideOnComplete = nil
                self.hide(triggerCallback: hideInfo.0, completion: hideInfo.1)
            }
            
        }
    }
    
    
    // MARK: - Gestures
    
    @objc fileprivate func didTap(_ gesture: UITapGestureRecognizer) {
        guard let type = type else {return}
        switch type {
        case .clarkOffline:
        break // Do nothing, ignore touches
        case .userDisconnected, .error(_):
            self.isUserInteractionEnabled = false
            self.hide(triggerCallback: true)
        }
    }
    
    @objc fileprivate func didPan(_ gesture: UIPanGestureRecognizer) {
        guard let type = type else {return}
        switch type {
        case .clarkOffline:
        break // Do nothing, ignore touches
        case .userDisconnected, .error(_):
            
            switch gesture.state {
            case .ended:
                self.isDragging = false
                if frame.maxY - (UIApplication.shared.statusBarFrame.size.height + navigationBarHeight) < actualBannerHeight * 0.5 {
                    self.hide(triggerCallback: true)
                } else {
                    self.showAnimated()
                }
                break
                
            case .began:
                self.isDragging = true
                break
                
            case .changed:
                
                guard let superview = self.superview, let gestureView = gesture.view else {
                    return
                }
                
                let translation = gesture.translation(in: superview)
                // Figure out where the user is trying to drag the view.
                let newCenter = CGPoint(x: superview.bounds.size.width / 2,
                                        y: gestureView.center.y + translation.y)
                
                // See if the new position is in bounds.
                let upperBounds = UIApplication.shared.statusBarFrame.size.height + navigationBarHeight - actualBannerHeight / 2.0
                let lowerBounds = UIApplication.shared.statusBarFrame.size.height + navigationBarHeight + actualBannerHeight / 2.0
                if (newCenter.y < upperBounds), gestureView.center.y != upperBounds {
                    // Moved too far up
                    let diff = gestureView.center.y - upperBounds
                    gesture.setTranslation(CGPoint(x:0.0, y: translation.y + diff), in: superview)
                    showConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + navigationBarHeight - actualBannerHeight
                    
                } else if (newCenter.y > lowerBounds) {
                    // Moved too far down
                    let diff = gestureView.center.y - lowerBounds
                    gesture.setTranslation(CGPoint(x:0.0, y: translation.y + diff), in: superview)
                    showConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + navigationBarHeight
                } else if let current = showConstraint?.constant {
                    showConstraint?.constant = current + translation.y
                    gesture.setTranslation(CGPoint.zero, in: superview)
                }
                
                break
                
            case .cancelled, .failed, .possible:
                break
            }
            
            
        }
    }
    
    
    // MARK: - Main show and hide methods
    
    private var showOnComplete:(BannerType, UINavigationController)?  // Store info in case the "show" function is called while the banner is already animating. After animation is over, use this stored info to show the new banner.
    public func showBanner(inNavigationController navigationController:UINavigationController, withType bannerType: BannerType) {
        
        guard self.type != bannerType else { return }  // If banner is already being shown, don't trigger any more code
        
        guard !isAnimating else {
            // Banner is animating. Save the new banner's info and present it when the current animation is over
            showOnComplete = (bannerType, navigationController)
            return
        }
        showOnComplete = nil
        
        // Check if banner is the same and already showing
        switch bannerType {
            
        case BannerType.userDisconnected:
            self.barTintColor = UIColor.dodgerBlue
            self.titleLabel.textColor = UIColor.white
            
            /// Content
            self.imageView.image = #imageLiteral(resourceName: "wifi_icon")
            self.titleLabel.text = "You’re not connected to the internet"
            self.subtitleLabel.text = nil
            self.iconSize =  CGSize(width: 20, height: 17)
            
            self.xImageView.isHidden = false
            
        case BannerType.clarkOffline:
            self.barTintColor = UIColor.indianKhaki
            self.titleLabel.textColor = UIColor.white
            
            /// Content
            self.imageView.image = #imageLiteral(resourceName: "clarksleeps")
            self.titleLabel.text = "I'm away at the moment, but I'll respond as soon as I'm back!"
            self.subtitleLabel.text = nil
            self.iconSize =  CGSize(width: 41, height: 42)
            
            self.xImageView.isHidden = true
            
        case BannerType.error(let errorString):
            self.barTintColor = UIColor.robinsEggBlue
            self.titleLabel.textColor = UIColor.white
            
            /// Content
            self.imageView.image = nil
            self.titleLabel.text = errorString
            self.subtitleLabel.text = nil
            self.iconSize =  CGSize(width: 41, height: 42)
            
            self.xImageView.isHidden = false
            
        }
        
        self.type = bannerType
        
        self.navigationBarHeight = navigationController.navigationBar.frame.size.height
        
        self.isUserInteractionEnabled = true
        
        navigationController.view.insertSubview(self, belowSubview: navigationController.navigationBar)
        navigationController.view.isUserInteractionEnabled = true
        navigationController.view.layoutIfNeeded()
        
        self.updateUI()
        
        self.showAnimated()
    }
    
    private var hideOnComplete:(Bool, (()->Void)?)? = nil  // Store info in case the "hide" function is called while the banner is already animating. After animation is over, use this stored info to hide the new banner.
    
    public func hide(triggerCallback:Bool, completion:(()->Void)? = nil) {
        
        guard !self.isDragging else {
            return
        }
        
        guard self.superview != nil else {
            isAnimating = false
            return
        }
        
        // Case are in animation of the hide
        guard !isAnimating else {
            // Banner is animating. Save the hiding info and hide the banner when the current animation is over
            hideOnComplete = (triggerCallback, completion)
            return
        }
        
        isAnimating = true
        hideOnComplete = nil
        
        // Set the constraint here and call layoutIfNeeded on the superview within the animation block to animate the change
        showConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + self.navigationBarHeight - frame.size.height
        
        /// Show animation
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.superview?.layoutIfNeeded()
            
            // Send the banner height to the chat view controller so it can set up its insets correctly
            let userInfo = ["bannerHeight":CGFloat(0.0)]
            NotificationCenter.default.post(name: setCollectionViewInsets, object: nil, userInfo: userInfo)
        }) {[weak self] (finished) in
            
            self?.removeFromSuperview()
            UIApplication.shared.delegate?.window??.windowLevel = UIWindowLevelNormal
            
            self?.isAnimating = false
            let typeOfHiddenAlert = self?.type  // Copy the type info
            self?.type = nil  // reset the type so when the hide callback is called, the bannerManager doesn't think a banner is still being shown. A type of "nil" is read as no banner being shown.
            
            if let showOnComplete = self?.showOnComplete {
                // Check if the banner was requested to show while it was animating to hide. If so, show the new banner.
                let nav = showOnComplete.1
                let type = showOnComplete.0
                self?.showOnComplete = nil  // Make sure this is reset before calling showBanner
                self?.showBanner(inNavigationController: nav, withType: type)
            }
            
            // Use the copied type data to send back in the callback if needed.
            if let type = typeOfHiddenAlert, triggerCallback {
                ChatViewBanner.hideCallback?(type)
            }
            
            completion?()
            
            
        }
    }
}

