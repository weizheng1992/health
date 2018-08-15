//
//  WebViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import Alamofire

open class WebViewController: UIViewController {
    
    // MARK: Properties
    
    @objc dynamic
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    open lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tintColor = .main
        return progressView
    }()
    
    var url: URLConvertible?
    
    // MARK: Initialization
    
    init(url: URLConvertible? = nil) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
        
        removeObserver(self, forKeyPath: "webView.title")
        removeObserver(self, forKeyPath: "webView.estimatedProgress")
    }
    
    // MARK: View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureWebView()
        configureProgressView()
        
        load(url)
    }
    
    // MARK: Layout
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topInset: CGFloat
        if #available(iOS 11.0, *) {
            topInset = navigationController?.navigationBar.frame.maxY ?? (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
        } else {
            topInset = navigationController?.navigationBar.frame.maxY ?? 0.0
        }
        
        progressView.frame = CGRect(x: 0.0, y: topInset, width: view.frame.width, height: 2.0)
        webView.frame = view.frame
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.title = ""
    }
    
    private func configureWebView() {
        view.backgroundColor = .white
        view.addSubview(webView)
        
        addObserver(self, forKeyPath: "webView.title", options: .new, context: nil)
        addObserver(self, forKeyPath: "webView.estimatedProgress", options: .new, context: nil)
    }
    
    private func configureProgressView() {
        view.addSubview(progressView)
    }
    
    // MARK: Actions
    
    public func load(_ url: URLConvertible?) {
        do {
            if let aUrl = try url?.asURL() {
                webView.load(URLRequest(url: aUrl))
            }
        } catch {
            
        }
    }
    
    public func reload() {
        webView.reload()
    }
    
    public func goBack() {
        webView.goBack()
    }
    
    public func goForward() {
        webView.goForward()
    }
    
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
//        do {
//            try Compass.shared.handle(navigationAction.request.url)
//            decisionHandler(.cancel)
//        } catch CompassError.schemeNotMatch(let URL) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(URL)
//            }
//            decisionHandler(.cancel)
//        } catch {
            decisionHandler(.allow)
//        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if challenge.protectionSpace.authenticationMethod != NSURLAuthenticationMethodServerTrust {
            completionHandler(.performDefaultHandling, nil)
        } else {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
    
    @available(iOS 9.0, *)
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate {
    
    //    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    //
    //    }
    
    @available(iOS 9.0, *)
    public func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    //    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
    //
    //    }
    //
    //    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
    //
    //    }
    //
    //    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void) {
    //
    //    }
    //
    //    @available(iOS 10.0, *)
    //    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
    //
    //    }
    //
    //    @available(iOS 10.0, *)
    //    public func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
    //
    //    }
    
    @available(iOS 10.0, *)
    public func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        
    }
    
}

// MARK: - KVO

extension WebViewController {
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "webView.title" {
            navigationItem.title = webView.title
        } else if keyPath == "webView.estimatedProgress" {
            if webView.estimatedProgress == 1.0 {
                progressView.setProgress(0, animated: false)
            } else {
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
