//
//  PhotoDetailsViewController.swift
//  Day2Lab
//
//  Created by Rhian Chavez on 6/22/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var imageHolder: UIImageView!
    var url: URL? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageHolder.af_setImage(withURL: url!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
