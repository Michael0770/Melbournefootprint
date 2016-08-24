//
//  ViewDetailsController.swift
//  melbourne1
//
//  Created by zihaowang on 17/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase


class ViewDetailsController: UIViewController,UIScrollViewDelegate {

    var scrollV : UIScrollView!
    var newImageView : UIImageView!
    
    var currentArtwork : Artworks?
    
    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(imageTapped))
        imageView.userInteractionEnabled = true

        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        typeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        typeLabel.numberOfLines = 0;
       self.nameLabel.text = currentArtwork?.Name
        self.dateLabel.text = currentArtwork?.Date
        self.artistLabel.text = currentArtwork?.Artist
        self.typeLabel.text = currentArtwork?.Structure
        
            self.textL.text = currentArtwork?.Descriptions
        self.textL.sizeToFit()
                imageView.image = nil
        if let photo = currentArtwork!.Photo{
            self.imageView.loadImageUsingCacheWithUrlString(photo)}

      
        
//        if let imageUrl = currentArtwork?.Photo {
//            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imageUrl)!,completionHandler: {(data,response,error) -> Void in
//                if error != nil {
//                print(error)
//                    return
//                }
//            let image = UIImage(data: data!)
//                dispatch_async(dispatch_get_main_queue(), {() -> Void in
//                    self.imageView.image = image
//                    ;
//                    
//            
//                })
//            
//            }).resume()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state  == .Ended{
            
        let imageView = sender.view as! UIImageView
          newImageView = UIImageView(image: imageView.image)
          scrollV = UIScrollView()
           scrollV.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            scrollV.minimumZoomScale=1
            scrollV.maximumZoomScale=3
            scrollV.bounces=false
            scrollV.delegate=self;
        newImageView.frame = CGRectMake(0, 0,scrollV.frame.width ,scrollV.frame.height)
       newImageView.backgroundColor = .blackColor()
       newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self, action: #selector(ViewDetailsController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        scrollV.addSubview(newImageView)
        self.view.addSubview(scrollV)
        }
    
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.newImageView
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view!.removeFromSuperview()
        scrollV.removeFromSuperview()
    }

    

}

