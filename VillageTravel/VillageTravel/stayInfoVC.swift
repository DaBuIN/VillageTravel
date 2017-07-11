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
    var itemList:Array<String> = ["電話", "地址", "開放時間", "特色"]
    let itemDict:[String:String] = ["電話":"Tel", "地址":"Address", "開放時間":"OpenHours", "特色":"StayFeature"]
    var staySelectedIndex:Int? = nil
    var stayPhotoPath:String?
    
    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let cellNum = itemList?.count ?? app.myStayData[staySelectedIndex!].count
        let cellNum = itemDict.count
        return cellNum
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! stayInfoCell
        
//        let key = itemList?[indexPath.row]
        let item:String = itemList[indexPath.row]
        let key:String = itemDict[item]!
        let detail:String = app.myStayData[staySelectedIndex!][key] as! String
        
//        print("\(indexPath.row):\(key), \(detail)")
        
        cell.infoItem.text = item
        cell.infoDetail.text = detail
        

        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let staySelectedIndex = staySelectedIndex {
//            print("stayInfoVC: \(staySelectedIndex)")
            
            let stayTitle = app.myStayData[staySelectedIndex]["Name"] as! String
//            print("stayInfoVC: \(stayTitle)")
//            for (key,val) in app.myStayData[staySelectedIndex] {
//                print("\(key) : \(val)")
//            }
            
            navBar.topItem?.title = stayTitle

            if let photoPath = stayPhotoPath {
                imgViewPhoto.image = UIImage(contentsOfFile: photoPath)
            } else {
                imgViewPhoto.image = UIImage(named: "none.png")
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
