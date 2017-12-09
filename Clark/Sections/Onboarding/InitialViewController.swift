//
//  InitialViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import WebKit
import SnapKit
import SwiftyJSON
import PromiseKit
import SVProgressHUD
import TwilioChatClient
import EZSwiftExtensions

/// Communication with webview
///
/// - token: Authentication token key
/// - resetPassword: Reset passwork key
enum JSCalls: String {
    case token = "token"
    case loginToken = "login_token"
    case profileToken = "profile_token"
    case resetPassword = "reset_password_completed"
}

/// Onboarding flow view controller
class InitialViewController: UIViewController {

    /// Status bar setup
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// WebView container
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let config = WKWebViewConfiguration()
            
            config.allowsInlineMediaPlayback = true
            config.userContentController = {
                let userContentController = WKUserContentController()
                
                /// Message handlers
                userContentController.add(self, name: JSCalls.token.rawValue)
                userContentController.add(self, name: JSCalls.loginToken.rawValue)
                userContentController.add(self, name: JSCalls.profileToken.rawValue)
                userContentController.add(self, name: JSCalls.resetPassword.rawValue)
                
                return userContentController
            }()
            
            return config
        }())
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    // MARK: - Initialization
    /// Controller initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        
        /// Clear
        clearCache()
        
        /// Load onboarding url
        let onboardinkLink = MacroEnviroment == "Prod" ? "https://onboarding.hiclark.com/" : "https://onboarding-qa.hiclark.com/"
        
        if let url = URL(string: onboardinkLink) {
            webView.load(URLRequest(url: url))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    /// View did appear setup
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s0)
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onExitFullScreen), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
    }
    
    /// View did load setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Webview background
        webView.backgroundColor = UIColor.black
        
        /// Setup UI
        initialSetup()
    }

    // MARK: - UI Setup
    /// Custom UI setup
    func initialSetup() {
        
        /// Web view
        view.addSubview(webView)
        
        /// Update constraints
        updateViewConstraints()
    }
    
    /// Constraints setup
    override func updateViewConstraints() {
        
        /// Place search setup
        webView.snp.makeConstraints { maker in
            maker.top.equalTo(view)
            maker.bottom.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Actions
    /// Called when full screen closes
    func onExitFullScreen() {
        
        if webView.title == "Put your tutoring business on auto-pilot with Clark from Clark on Vimeo" {
            webView.goBack()
        }
    }
}

// MARK: - WKScriptMessageHandler
extension InitialViewController: WKScriptMessageHandler {
    /// User content handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case JSCalls.resetPassword.rawValue:
            webView.goBack()
            webView.goBack()
            
        case JSCalls.token.rawValue, JSCalls.loginToken.rawValue, JSCalls.profileToken.rawValue:

            guard let token = JSON(message.body)[JSCalls.token.rawValue].string, let _ = JSON(message.body)["version"].null else {
                return
            }
            
            /// Analytics
            Analytics.trackEventWithID(.s0_1)
            
            /// Chat transition
            SVProgressHUD.show()
            
            /// Auth call
            TutorAdapter.onboarding(key: token).then { response-> Promise<[UIViewController]> in
                    
                /// Safety check
                if let response = response {
                    let config = Config.shared
                    config.currentTutor = response
                }
                
                /// Hide onboarding check
                let shouldShowOnboarding = message.name == JSCalls.token.rawValue

                /// Transition
                SVProgressHUD.dismiss()
                return MainRouteHandler.initialTransition(showOnboardingFinished: shouldShowOnboarding)
                }.catch { error-> Void in
                    SVProgressHUD.dismiss()
                    /// Show error
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        default: break
        }
    }
    
    /// Clear up webView cache
    func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
}

// MARK: - Webview delegate
extension InitialViewController: WKUIDelegate {
    
    /// Webview configuration setup
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension InitialViewController: WKNavigationDelegate, UIScrollViewDelegate {
    /// Web view handler
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: NSLocalizedString("Could not load page", comment: ""), message: NSLocalizedString("Looks like the server isn't running.", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Bummer", comment: ""), style: .default, handler: nil))
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    /// Navigation setup
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)
    }
}
