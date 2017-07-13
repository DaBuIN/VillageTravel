//
//  ViewController.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 02/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let app = UIApplication.shared.delegate as! AppDelegate
    private let fmgr = FileManager.default
    private let docDir = NSHomeDirectory() + "/Documents"
    private var photoDir:String?
    
    var staySelectedIndex:Int?
   

//    private var app.myStayData:Array<[String:AnyObject]> = []
    
    @IBAction func backHere( segue: UIStoryboardSegue ) {
        print("back mainTableVC")
    }
    
    
    @IBAction func refreshData(_ sender: Any) {
//        DispatchQueue.main.async {
//            self.getJSON(self)
//        }
//        getJSON(self)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
//        print(indexPath.row)
//        print(cell.title.text!)

        staySelectedIndex = indexPath.row
        self.performSegue(withIdentifier: "segTableToDetail", sender: nil)
        
        if let infoVC = storyboard?.instantiateViewController(withIdentifier: "stayInfo") {
            
            show( infoVC, sender: self)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.myStayData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell" ) as! CustomTableViewCell
//        let photoPath_str = app.myStayData[indexPath.row]["photpPath"] as! String
        let photoPath_str = photoDir! + "/" + ( app.myStayData[indexPath.row]["ID"] as! String ) + ".jpg"
        
        
        if fmgr.fileExists(atPath: photoPath_str) {
            
            cell.img.image = UIImage(contentsOfFile: photoPath_str)

        } else {
            
            cell.img.image = UIImage(named: "none.png")

        }

        
        cell.title.text = self.app.myStayData[indexPath.row]["Name"] as! String
        cell.address.text = self.app.myStayData[indexPath.row]["Address"] as! String

 
        return cell
        
    }
    
    private func getPhotoPath( stayInfoID: String ) -> String {
        var path:String?
        
        path = self.photoDir! + "/" + stayInfoID + ".jpg"
        
        return path!
    }
    
   
    private func initStat() {
        
        self.photoDir = self.docDir + "/placePhoto"
        
        if !self.fmgr.fileExists(atPath: self.photoDir!) {
            do {
                try self.fmgr.createDirectory(atPath: self.photoDir!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStat()

        print("OK")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        print(staySelectedIndex!)
        
        if segue.identifier == "segTableToDetail" {
            
            let vc = segue.destination as! stayInfoVC
            vc.staySelectedIndex = self.staySelectedIndex
            vc.stayPhotoPath = getPhotoPath(stayInfoID: app.myStayData[staySelectedIndex!]["ID"] as! String)
        }
        

    }


}

