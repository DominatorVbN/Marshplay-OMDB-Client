//
//  Alert.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 08/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

class Alert {
    private init(){}
    static let shared = Alert()
    
    var loaderView: UIAlertController?

    func showLoader(message: String = "Please wait..."){
        
        if var topController = WindowWrapper.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.view.tintColor = UIColor(named: "accent")!
            //CGRectMake(10, 5, 50, 50)
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            
            alert.view.addSubview(loadingIndicator)
            loaderView = alert
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideLoader()  {
        DispatchQueue.main.async {
            self.loaderView?.dismiss(animated: true, completion: nil)
        }
    }
}
