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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bArr.insert(b1, atIndex: bArr.count)
        bArr.insert(b2, atIndex: bArr.count)
        bArr.insert(b3, atIndex: bArr.count)
        bArr.insert(b4, atIndex: bArr.count)
        bArr.insert(b5, atIndex: bArr.count)
        bArr.insert(b6, atIndex: bArr.count)
        for button in bArr {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
            let img = UIImageView(frame: CGRectMake(10, 0, 28, 28))
            img.center = CGPointMake(img.center.x, button.frame.height/2)
            img.image = UIImage(named: (button.titleLabel?.text)!)
            button.addSubview(img)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBarHidden = true
        navigationController?.navigationBar.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
