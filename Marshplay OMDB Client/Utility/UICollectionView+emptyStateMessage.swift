//
//  UICollectionView+emptyStateMessage.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyStateMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor(named: "accent")!
        messageLabel.shadowColor = UIColor(named: "accentShadow")!
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restoreEmptyState() {
        self.backgroundView = nil
    }
}
