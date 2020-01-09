//
//  UIImageView+LoadImage.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        self.image = nil
        if let imageFromCache = ImageCacheStore.cache.object(forKey: NSString(string: link)) {
            self.contentMode =  contentMode
            self.image = imageFromCache
            return
        }
        
        self.startShimmeringAnimation()
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {(data, response, error) -> Void in
            DispatchQueue.main.async {
                self.stopShimmeringAnimation()
                self.contentMode =  contentMode
                if let data = data {
                    if let image = UIImage(data: data){
                        ImageCacheStore.cache.setObject(image, forKey: NSString(string: link))
                        self.image = image
                    }
                }
            }
            if let error = error{
                debugPrint("❌: \(error)")
                DispatchQueue.main.async {
                    // setting no image if image loading fails
                    self.image = self.getImageForName(name: "No Image")
                }
            }
        }).resume()
    }
    func getImageForName(name: String)->UIImage?{
        let containerView = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        containerView.backgroundColor = .systemGray4
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        label.text = name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: containerView.frame.height * 0.1)
        label.textAlignment = .center
        containerView.addSubview(label)
        containerView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(containerView.frame.size)
        containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

struct ImageCacheStore {
    static let cache = NSCache<NSString,UIImage>()
}
