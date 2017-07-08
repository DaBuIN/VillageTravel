//
//  ViewController.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 02/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let fmgr = FileManager.default
    private let docDir = NSHomeDirectory() + "/Documents"
    private var photoDir:String?
    
    private var myData:Array<[String:AnyObject]> = []
//    private var myData:Array< Dictionary<String, AnyObject> > = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell" ) as! CustomTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell" ) as! CustomTableViewCell
        
        let photoURL_str = myData[indexPath.row]["Photo"] as! String
        let photoPath_str = photoDir! + "/" + String( format: "%03i", indexPath.row ) + ".jpg"
        
        

        
        if fmgr.fileExists(atPath: photoPath_str) {
        
            myData[indexPath.row]["PhotoPath"] = photoPath_str as AnyObject
            DispatchQueue.main.async {
                cell.img.image = UIImage(contentsOfFile: photoPath_str)

            }
            
        } else {
            
                var isGetPhoto = true
//                let queue = DispatchQueue(label: "getPhoto")
            
//                queue.async {
                    do {
                        try self.wgetPhoto(photoURL_str, toPath: photoPath_str)
                    } catch {
                        print(error)
                        isGetPhoto = false
                    }
//                }
            
//                queue.async {
        
            DispatchQueue.main.async {
                
            
                    if isGetPhoto {
                        self.myData[indexPath.row]["PhotoPath"] = photoPath_str as AnyObject
                        cell.img.image = UIImage(contentsOfFile: photoPath_str)
                    } else {
                        cell.img.image = UIImage(named: "none.png")
                    }
                    
            }
//                }

            

//            cell.img.image = UIImage(named: "none.png")

        }

        DispatchQueue.main.async {
            cell.title.text = self.myData[indexPath.row]["Name"] as! String
            cell.address.text = self.myData[indexPath.row]["Address"] as! String
        }
        

        
        return cell
        
    }
    
    private func wgetPhoto(_ url_string: String, toPath: String ) throws {
        let url = URL(string: url_string)
        let req = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: req, completionHandler: {(data, resp, error) in
            
            if error == nil {
                print("wgetPhoto() OK")
                
                self.saveFile(data: data!, destination: toPath )
                
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
    
    @IBAction func getJSON(_ sender: Any) {
        
        do {
            let url = URL( string: "http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelStay.aspx" )
            let data = try Data(contentsOf: url!)
            
            parseJSON( json: data)
            
//            self.tableView.reloadData()
            
        } catch {
            print(error)
        }
    }
    
    private func parseJSON( json: Data ) {
        print("parseJSON(): OK")
        
        do {
            if let jsonObj = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) {
                
                myData = []
                
                let allObj = jsonObj as! [[String:AnyObject]]
                print(allObj.count)
                
                for row in allObj {
                    for (key,val) in row {
                        print("\(key) : \(val)")

                    }
                    
                    myData += [row]
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                }
                
            }
            
            
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(docDir)
        
        photoDir = docDir + "/placePhoto"
        
        if !fmgr.fileExists(atPath: photoDir!) {
            do {
                try fmgr.createDirectory(atPath: photoDir!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

