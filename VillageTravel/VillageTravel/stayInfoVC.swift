//
//  stayInfoVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 07/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class stayInfoVC: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var staySelected:Int? = nil
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let staySelected = staySelected {
            print("stayInfoVC: \(staySelected)")
            
            let stayTitle = app.myStayData[staySelected]["Name"] as! String
            print("stayInfoVC: \(stayTitle)")
            
            navBar.topItem?.title = stayTitle
        }
        
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
