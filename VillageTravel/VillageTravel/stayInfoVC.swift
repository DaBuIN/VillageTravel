//
//  stayInfoVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 07/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class stayInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let app = UIApplication.shared.delegate as! AppDelegate
    var itemList:Array<String>?
    var staySelectedIndex:Int? = nil
    
    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNum = itemList?.count ?? app.myStayData[staySelectedIndex!].count
        
        return cellNum
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! stayInfoCell
        
        let key = itemList?[indexPath.row]
        
        cell.infoItem.text = key
        cell.infoDetail.text = app.myStayData[staySelectedIndex!][key!] as! String
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let staySelectedIndex = staySelectedIndex {
//            print("stayInfoVC: \(staySelectedIndex)")
            
            let stayTitle = app.myStayData[staySelectedIndex]["Name"] as! String
            print("stayInfoVC: \(stayTitle)")
            
            for (key,val) in app.myStayData[staySelectedIndex] {
                print("\(key) : \(val)")
            }
            
            navBar.topItem?.title = stayTitle

            itemList = []
            for key in app.myStayData[staySelectedIndex].keys {
                itemList?.append(key)
            }

            imgViewPhoto.image = UIImage(named: "none.png")
            
//            tableView.reloadData()

        }
        
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
