//
//  ViewController.swift
//  Facebook-DoesAll-App
//
//  Created by Lala Vaishno De on 6/8/15.
//  Copyright (c) 2015 Casa Wee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var fbButtonView : FBLoginView!
    @IBOutlet var fbPicView : FBProfilePictureView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbButtonView.delegate = self
        self.fbButtonView.readPermissions = ["public_profile" ,"email"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK : Fb Functions
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        println("user logged in")
        
    }

    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        
        println("user logged out")
        
        fbPicView.profileID = nil
        
        name.text = ""
        email.text = ""
        
        
    }

    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        println("\(user)")
        
        
        fbPicView.profileID = user.objectForKey("id") as String
        
        name.text = user.objectForKey("name") as? String
        
        email.text = user.objectForKey("email") as? String
        
    }

    
    
    // MARK : Posting to Facebook
    
    
    
    
    // Writing a post on Facebook
    
    @IBAction func PosttoFbClicked(sender: AnyObject) {
        
        if FBDialogs.canPresentShareDialogWithPhotos() {
            
            // use the iOS App share feature
            FBDialogs.presentShareDialogWithLink(nil, handler: { (call, results, error) -> Void in
                
                if(error == nil) {
                    println("success")
                } else {
                    println("error")
                }
            })
        } else {
            // user does have the Facebook iOS application installed
            // use feed dialog
            
            FBWebDialogs.presentFeedDialogModallyWithSession(nil, parameters: nil, handler: { (result, resultURL, error) -> Void in
                
                if(error == nil) {
                    println("success")
                } else {
                    println("error")
                }
            })
        }
    }
    
    
    
    
    // Sharing a link on Facebook
    
    @IBAction func ShareLinkClicked(sender: AnyObject) {
    
        var params : FBLinkShareParams = FBLinkShareParams()
        params.link = NSURL(string: "http://googleblog.blogspot.sg/")
        
        
        // checking again to see if user has FB app installed
        
        if FBDialogs.canPresentShareDialogWithPhotos() {
            
            FBDialogs.presentShareDialogWithLink(params.link, handler: { (call, results, error) -> Void in
                
                if(error == nil) {
                    println("success")
                } else {
                    println("error")
                }
            })
        } else {
            
            var paramsArr : NSDictionary = NSDictionary(objectsAndKeys: "Test Share YouTube Link", "name", "Test 1", "caption", "Love this song :P", "description" , "https://www.youtube.com/watch?v=n06H7OcPd-g", "link")
            
            FBWebDialogs.presentFeedDialogModallyWithSession(nil, parameters: paramsArr, handler: { (result, resultURL, error) -> Void in
                
                if(error == nil) {
                    println("success")
                } else {
                    println("error")
                }
            })
        }
    }
    
    
    // Sharing a photo on Facebook
    
    @IBAction func shareButtonClicked(sender: AnyObject) {
        
        if FBDialogs.canPresentShareDialogWithPhotos() {
            
            var imagePicker : UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: { () -> Void in
            })
            
        } else {
            println("no fb app installed")
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let theInfo : NSDictionary = info as NSDictionary
        
        let img : UIImage = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        let params : FBPhotoParams = FBPhotoParams()
        params.photos = [img]
        
        
        FBDialogs.presentShareDialogWithPhotoParams(params, clientState: nil) { (call, results, error) -> Void in
            
            if(error == nil) {
                println("success")
            } else {
                println("error")
            }
        }
        
    }
    
}

