//
//  ViewDetailsController.swift
//  melbourne1
//
//  Created by zihaowang on 17/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation


class ViewDetailsController: UIViewController,UIScrollViewDelegate {

    
    //for images
    var imageArray: NSArray?
    var index: NSInteger?
    var pageController: UIPageControl?
    //swip image view
    var scrollV : UIScrollView!
    var newImageView : UIImageView!
    var currentArtwork : Artworks?
    @IBOutlet weak var textL: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialization
        index = 0
        imageArray = [(currentArtwork?.Photo)!,(currentArtwork?.PhotoOne)!,(currentArtwork?.PhotoTwo)!]
        
        //add tap gesture for image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(imageTapped))
        imageView.userInteractionEnabled = true
        
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        typeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        typeLabel.numberOfLines = 0;
        //get info that passed by tableview
        self.nameLabel.text = currentArtwork?.Name
        self.dateLabel.text = currentArtwork?.Date
        self.artistLabel.text = currentArtwork?.Artist
        self.typeLabel.text = currentArtwork?.Structure
        
        self.textL.text = currentArtwork?.Descriptions
        self.textL.sizeToFit()
        imageView.image = nil
        if let photo = currentArtwork!.Photo{
            self.imageView.loadImageUsingCacheWithUrlString(photo)}
        
        addSwipGesture();
        addPageController();
        
        
        
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
    
    @IBAction func navigation(sender: AnyObject) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        let fullNameArr = currentArtwork!.Coordinates!.componentsSeparatedByString(",")
        
        let firstName: String = fullNameArr[0]
        let lastName: String = fullNameArr[1]
        
        let latitude1 = String(firstName.characters.dropFirst())
        let longtitude1 = String(lastName.characters.dropLast())
        
        
        let latitude2 = (latitude1  as NSString).doubleValue
        let longitude2 = (longtitude1 as NSString).doubleValue
        
        let inLocation = CLLocationCoordinate2D(latitude: latitude2, longitude: longitude2)

        let artMap = ArtworkForMap(title: (currentArtwork?.Name)!, locationName: (currentArtwork?.Address)!, discipline: (currentArtwork?.AlternateName)!, coordinate: inLocation)

        artMap.mapItem().openInMapsWithLaunchOptions(launchOptions)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //define image view tap action
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
    
    //add the page controller
    func addPageController(){
        
        pageController = UIPageControl(frame: CGRectMake(0,imageView.frame.origin.y + imageView.bounds.size.height-1,imageView.bounds.size.width,30));
        pageController?.numberOfPages = (imageArray?.count)!;
        pageController?.currentPage = 0;
        pageController?.pageIndicatorTintColor = UIColor.orangeColor();
        pageController?.currentPageIndicatorTintColor = UIColor.whiteColor();
        self.imageView.addSubview(pageController!);
        
    }
    // add swip gesture
    func addSwipGesture(){
        
        let leftSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewDetailsController.swipAction(_:)));
        leftSwip.direction = UISwipeGestureRecognizerDirection.Left;
        imageView.addGestureRecognizer(leftSwip);
        
        let rightSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewDetailsController.swipAction(_:)));
        rightSwip.direction = UISwipeGestureRecognizerDirection.Right;
        imageView.addGestureRecognizer(rightSwip);
        
    }
    //method for swip gesture
    func swipAction(swip:UISwipeGestureRecognizer){
        
        if swip.direction == UISwipeGestureRecognizerDirection.Left{
            leftAnimationAction();
        }else if swip.direction == UISwipeGestureRecognizerDirection.Right{
            rightAnimationAction();
        }
    }
    //left swip action
    func leftAnimationAction(){
        index = index! + 1;
        if index! > (imageArray?.count)! - 1{
            self.index = 0;
        }
        
        //  imageView.image = UIImage(named: (imageArray![index!]) as! String);
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.loadImageUsingCacheWithUrlString(imageArray![index!] as! String)
        addAnimation(1);
        
    }
    // right swip action
    
    func rightAnimationAction(){
        
        index = index! - 1;
        if index! < 0{
            self.index = (imageArray?.count)! - 1;
        }
        //   imageView.image = UIImage(named: (imageArray![index!]) as! String);
       
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.loadImageUsingCacheWithUrlString(imageArray![index!] as! String)
        addAnimation(0);
        
    }
    //add animation
    func addAnimation(isLeft : NSInteger){
        let animation = CATransition();
        animation.duration = 0.4;
        animation.type = "push";
        if isLeft == 1{
            animation.subtype = kCATransitionFromRight;
        }else{
            animation.subtype = kCATransitionFromLeft;
        }
        imageView.layer.addAnimation(animation, forKey: "transition");
        
        pageController?.currentPage = index!;
        
    }
    
}


