//
//  WebViewController.swift
//  PutItOn
//
//  Created by 박현준 on 2023/03/31.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController {

    var text = ""
    var url = ""
    
    let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        title = "실시간"
        
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadWebView()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadWebView() {
//        var components = URLComponents(string: url)!
//        components.queryItems = [ URLQueryItem(name: "query", value: text) ]
        var components = URLComponents(string: url)!
        let request = URLRequest(url: components.url!)
        
        webView.load(request)
        
        //animation
        webView.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.webView.alpha = 1
                }) { _ in
                    
                }
    }


}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    // 유효 도메인 체크
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(navigationAction.request.url?.absoluteString ?? "")" )
        
        decisionHandler(.allow)
    }
    
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
}
