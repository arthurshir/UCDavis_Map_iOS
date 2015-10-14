//
//  LabelMarker.swift
//  CMPortfolio
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 Aashir. All rights reserved.
//

import UIKit
import GoogleMaps

class LabelMarker: UIView {

    var rectView = UIView()
    var titleLabel = UILabel()
    var bottom = UIImageView()  // This is the bottom \/ that goes on the bottom of the callout
    
    class func markerViewWithText(text: String) -> LabelMarker {
        let lm = LabelMarker()
        var markerBodyHeight = 25
        lm.backgroundColor = UIColor.clearColor()
        //lm.layer.borderWidth = 0.5
        
        // Set up titleLabel. Label.sizeToFit will determine how large the entire marker will be.
        lm.titleLabel.text = text
        lm.titleLabel.font = UIFont(name: "Avenir-Medium", size: 10)
        lm.titleLabel.textColor = UIColor.whiteColor()
        lm.titleLabel.textAlignment = NSTextAlignment.Center
        lm.titleLabel.sizeToFit()
        
        // Adjust Frames & Centers to account for Text
        lm.frame = CGRectMake(0, 0, lm.titleLabel.frame.width + 12, 25)
        lm.rectView.frame = CGRectMake(0, 0, lm.titleLabel.frame.width + 8, 17)
        lm.rectView.center = CGPointMake(lm.frame.width/2, lm.rectView.center.y)
        lm.titleLabel.center = CGPointMake(lm.rectView.frame.width/2, lm.rectView.frame.height/2)
        lm.bottom.frame = CGRectMake(0, 12, 12, 12)
        lm.bottom.center = CGPointMake(lm.frame.width/2, lm.bottom.center.y)
        
        // Set up Views
        lm.rectView.layer.cornerRadius = 2
        lm.rectView.layer.masksToBounds = true
        lm.rectView.backgroundColor = Functions.colorWithHexString("1E466B")
        lm.bottom.image = UIImage(named: "Callout_PointedBottom")
        
        // Add Views
        lm.addSubview(lm.bottom)
        lm.addSubview(lm.rectView)
        lm.rectView.addSubview(lm.titleLabel)
        
        return lm
    }
    
    class func markerWithText(text: String) -> BuildingMarker {
        let marker = BuildingMarker()
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.icon = Functions.imageWithView( markerViewWithText(text) )
        marker.title = "🚶"
        return marker
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
