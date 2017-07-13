//
//  WelcomeVC.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 13/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    private let fmgr = FileManager.default

    private let docDir = NSHomeDirectory() + "/Documents"
    private var photoDir:String?

    @IBAction func showMainTable(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "mainTableVC") {
        
            show(vc, sender: self)
        }
    }
    

    private func lauchData() {
        DispatchQueue.global().sync {
            self.getJSON()
        }
        
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
        
        print("Welcome OK")
        
        DispatchQueue.global().async {
            self.initStat()
            print(self.docDir)
        }
        
        DispatchQueue.global().async {
            self.lauchData()

        }
        
    }
    

   
    private func wgetPhoto(_ url_string: String, toPath: String ) throws {
        let url = URL(string: url_string)
        let req = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: req, completionHandler: {(data, resp, error) in
            
            if error == nil {
                print("wgetPhoto() OK")
                
                DispatchQueue.global().async {
                    self.saveFile(data: data!, destination: toPath )
                }
                
            } else {
                print("wgetPhoto() fails")
            }
        })
        
        task.resume()
    }
    
    private func saveFile(data: Data, destination: String) {
        let url = URL(fileURLWithPath: destination )
        do {
            try data.write(to: url )
        } catch {
            print(error)
        }
    }
    
    private func getJSON() {
        do {
            let url = URL( string: "http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelStay.aspx" )
            let data = try Data(contentsOf: url!)
            
            parseJSON( json: data, toDir: self.photoDir! )
            
        } catch {
            print(error)
        }
    }
    
    private func parseJSON( json: Data, toDir: String ) {
        
        do {
            if let jsonObj = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) {
                
                app.myStayData = []
                
                let allObj = jsonObj as! [[String:AnyObject]]
                
                for row in allObj {
                    
                    DispatchQueue.main.async {
                        
                        self.initStat()
                        self.app.myStayData += [row]
                        
                        do {
                            
                            let photoURL_str = row["Photo"] as! String
//                            let photoPath_str = self.photoDir! + "/" + ( row["ID"] as! String ) + ".jpg"
                            let photoPath_str = toDir + "/" + ( row["ID"] as! String ) + ".jpg"

                            if !self.fmgr.fileExists(atPath: photoPath_str) {
                                try self.wgetPhoto(photoURL_str, toPath: photoPath_str)
                            }
                            
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                }
                
            }
            
            
        } catch {
            print(error)
        }
    }
    
    

}
