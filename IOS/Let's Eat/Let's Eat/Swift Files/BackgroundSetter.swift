//
//  deneme.swift
//  Let's Eat
//
//  Created by Vidal_HARA on 10.03.2015.
//  Copyright (c) 2015 vidal hara S002866. All rights reserved.
//

import UIKit

class BackgroundSetter {
    var firstPictLoaded = false
    var viewControler: UIViewController
    init(viewControler: UIViewController) {
        self.viewControler = viewControler
    }
    func getBackgroundView(){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {() -> Void in
            let url = "http://lorempixel.com/1200/1200/food/"
            if self.firstPictLoaded == true{
                sleep(3)
            }
            if let nsurl = NSURL(string: url) {
                if let nsdata = NSData(contentsOfURL: nsurl) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let image = UIImage(data: nsdata) {
                            self.viewControler.view.backgroundColor = UIColor(patternImage: self.imageResize(image))
                            if self.isVisible() {
                                self.firstPictLoaded = true
                                self.getBackgroundView()
                            }
                        }
                    })
                }
            }
        })
    }
    
    func imageResize (imageObj:UIImage)-> UIImage{
        var mainScreenSize : CGSize = UIScreen.mainScreen().bounds.size
        var sizeChange = CGSizeMake(mainScreenSize.width, mainScreenSize.height)
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func isVisible() -> Bool{
        return (viewControler.isViewLoaded() && viewControler.view.window != nil)
    }
    
}