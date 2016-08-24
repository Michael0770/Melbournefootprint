//
//  Extensions.swift
//  melbourne1
//
//  Created by zihaowang on 19/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView{


    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        self.image = nil
        if let cachedImage = imageCache.objectForKey(urlString) as?
        UIImage
        {
            self.image = cachedImage
            return
        
        }
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!,completionHandler: {(data,response,error) in
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                if let downloadeImage = UIImage(data: data!)
                {
                imageCache.setObject(downloadeImage, forKey: urlString)
                    self.image = downloadeImage
                }
                            })
            
        }).resume()

    
    
    
    }
   












}
