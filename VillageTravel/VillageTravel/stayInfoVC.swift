//
//  stayInfoVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 07/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit
import MapKit

class stayInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    let app = UIApplication.shared.delegate as! AppDelegate
//    var itemList:Array<String> = ["電話", "地址", "開放時間", "特色"]
//    let itemDict:[String:String] = ["電話":"Tel", "地址":"Address", "開放時間":"OpenHours", "特色":"StayFeature"]
    var itemList:Array<String> = ["電話", "地址", "開放時間"]
    let itemDict:[String:String] = ["電話":"Tel", "地址":"Address", "開放時間":"OpenHours"]
    var staySelectedIndex:Int? = nil
    var stayPhotoPath:String?
    
    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webViewFeature: UIWebView!
    
    @IBAction func backInfo( sender: UIStoryboardSegue ) {
        print("Back info")
    }

    
    @IBAction func goNavMapVC(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "mapNavVC" ) {
            performSegue(withIdentifier: "segInfoToMap", sender: nil)
            show(vc, sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let cellNum = itemList?.count ?? app.myStayData[staySelectedIndex!].count
        let cellNum = itemList.count
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
        switch (key) {
            case "Tel":
                cell.infoDetail.numberOfLines = 1
            case "OpenHours":
                cell.infoDetail.numberOfLines = 3
            default:
                cell.infoDetail.numberOfLines = 2
                break
        }
        
        cell.infoDetail.text = detail
        
        
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let staySelectedIndex = staySelectedIndex {
//            print("stayInfoVC: \(staySelectedIndex)")
            
            let stayTitle = app.myStayData[staySelectedIndex]["Name"] as! String

            
            navBar.topItem?.title = stayTitle

            if let photoPath = stayPhotoPath {
                imgViewPhoto.image = UIImage(contentsOfFile: photoPath)
            } else {
                imgViewPhoto.image = UIImage(named: "none.png")
            }
            
            let strFeature_html = app.myStayData[staySelectedIndex]["StayFeature"] as! String
            
            webViewFeature.loadHTMLString(strFeature_html, baseURL: nil)
            
//            print(app.myStayData[staySelectedIndex]["Coordinate"] ?? "No GPS coordinate")
            
//            let coor_str = app.myStayData[staySelectedIndex]["Coordinate"]
//            let coor_array = coor_str?.components(separatedBy: ",")
//            print(coor_array?.description)
//            print(coor_array![0])
//            print(coor_array![1])
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segInfoToMap" {
            let destCoorStr:String = self.app.myStayData[self.staySelectedIndex!]["Coordinate"] as! String
            let destCoorArray:[String] = destCoorStr.components(separatedBy: ",")
            
            let vc = segue.destination as! MapNavVC
            
//            for str in destCoorArray {
//                var s:String = str
//                if let num = CLLocationDegrees(s) {
//                    print("prepare: \(num)")
//                } else {
//                    print("prepare: nil again")
//                }
//            }
            
            
            
            let lat:CLLocationDegrees = CLLocationDegrees(destCoorArray[0])!
            let lng:CLLocationDegrees = CLLocationDegrees(destCoorArray[1])!
            vc.locDest = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            vc.nameDest = self.app.myStayData[self.staySelectedIndex!]["Name"] as! String
            
            
//             = self.app.myStayData[self.staySelectedIndex!]["Name"] as! String
            print("prepare:\(lat), \(lng)")
            
        }
    }



}
