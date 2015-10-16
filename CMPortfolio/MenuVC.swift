//
//  MenuVC.swift
//  
//
//  Created by Arthur Shir on 10/12/15.
//
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var b5: UIButton!
    @IBOutlet var b6: UIButton!
    var bArr = [UIButton]()
    var savedCategoryIndex = 0
    
    override func viewDidLoad() {
        bArr.insert(b1, atIndex: bArr.count)
        bArr.insert(b2, atIndex: bArr.count)
        bArr.insert(b3, atIndex: bArr.count)
        bArr.insert(b4, atIndex: bArr.count)
        bArr.insert(b5, atIndex: bArr.count)
        bArr.insert(b6, atIndex: bArr.count)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
        //navigationController?.navigationBarHidden = true
        navigationController?.navigationBar.clipsToBounds = true
        
        // Set up Category Buttons
        for (var i = 0; i < bArr.count; i++) {
            let button = bArr[i]
            
            // Set Format
            button.layer.cornerRadius = 1
            button.layer.shadowOpacity = 0.2
            button.layer.shadowColor = UIColor.blackColor().CGColor
            
            // Set Image
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
            let img = UIImageView(frame: CGRectMake(10, 0, 28, 28))
            img.center = CGPointMake(img.center.x, button.frame.height/2)
            img.image = UIImage(named: (button.titleLabel?.text)!)
            button.addSubview(img)
            
            // Set Selection
            button.tag = i
            button.addTarget(self, action: "touchButton:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // Set up Favorites Button
        //b6.addTarget(self, action: "goToFavorites", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func goToFavorites() {
        
    }
    
    func touchButton(sender: UIButton) {
        savedCategoryIndex = sender.tag
        performSegueWithIdentifier("toList", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let lvc = segue.destinationViewController as! ListingsVC
        lvc.categoryIndex = savedCategoryIndex
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
