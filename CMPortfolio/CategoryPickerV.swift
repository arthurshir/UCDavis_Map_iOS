//
//  CategoryPickerV.swift
//  
//
//  Created by Arthur Shir on 10/10/15.
//
//

import UIKit

class CategoryPickerV: UIView {
    
    // ----- Customize ----- //
    var categories = ["Buildings", "Student Resources", "Housing & Dining", "Places of Interest", "Recreation", "Favorites"]
    var buttons = [UIButton]()
    var pickedView = UIView()
    var pickedHeight = 40
    var width = 210
    var heightM = 50
    var buttonHeight = 40
    var buttonWidth = 190
    
    
    
    class func makeCPV() -> CategoryPickerV {
        let cpv = CategoryPickerV()
        cpv.frame = CGRectMake( CGFloat(0), CGFloat(0), CGFloat(cpv.width), CGFloat(cpv.heightM*cpv.categories.count + 10) )
        cpv.backgroundColor = Functions.themeColor()
        cpv.frame = CGRectMake(0, -cpv.frame.height, cpv.frame.width, cpv.frame.height)
        cpv.layer.cornerRadius = 4
        cpv.layer.shadowOpacity = 0.3
        cpv.layer.masksToBounds = false
        
        cpv.setupButtons()
        
        cpv.pickedView.frame = Functions.makeFrame(0, y: 0, width: cpv.width, height: cpv.pickedHeight)
        cpv.pickedView.center = CGPointMake(cpv.center.x, cpv.buttons[0].center.y )
        cpv.pickedView.backgroundColor = UIColor.grayColor()
        cpv.insertSubview(cpv.pickedView, atIndex: 0)
        
        return cpv
    }
    
    
    func setupButtons() {
        for (var i = 0; i < categories.count; i++) {
            let b = UIButton(frame: Functions.makeFrame( (width - buttonWidth)/2, y: 10 +  i*heightM, width: buttonWidth, height: buttonHeight) )
            b.setTitle(categories[i], forState: UIControlState.Normal)
            b.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
            b.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            b.contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
            let img = UIImageView(frame: CGRectMake(3, 5, 26, 26))
            img.image = UIImage(named: categories[i])
            b.addSubview(img)
            
            //b.backgroundColor = UIColor.whiteColor()
            buttons.insert(b, atIndex: buttons.count )
            addSubview(b)
        }
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
