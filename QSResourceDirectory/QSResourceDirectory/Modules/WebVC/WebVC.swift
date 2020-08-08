//
//  WebVC.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    lazy var webView: WKWebView = {
        let v = WKWebView()
        v.navigationDelegate = self
        return v
    }()

    func openURLWithString(_ string: String) {
        guard let url = URL(string: string) else {
            debugPrint("Error while trying to open WebBrower")
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension WebVC: WKNavigationDelegate {
    override func loadView() {
        view = webView
    }
}
