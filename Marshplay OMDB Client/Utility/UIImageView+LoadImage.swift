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
        if let imageFromCache = ImageCacheStore.cache.object(forKey: NSString(string: link)) {
            self.contentMode =  contentMode
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    if let image = UIImage(data: data){
                        ImageCacheStore.cache.setObject(image, forKey: NSString(string: link))
                        self.image = image
                    }
                }
            }
        }).resume()
    }
}

struct ImageCacheStore {
    static let cache = NSCache<NSString,UIImage>()
}
