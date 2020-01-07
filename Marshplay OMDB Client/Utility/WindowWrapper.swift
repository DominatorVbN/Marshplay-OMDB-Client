//
//  WindowWrapper.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 08/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

struct WindowWrapper{
    static var window: UIWindow? {
        get{
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0}).first?.windows
                .filter({$0.isKeyWindow}).first
            return window
        }
    }
    static func dismissKeyboard(){
        window?.endEditing(true)
    }
}
