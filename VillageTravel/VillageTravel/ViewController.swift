//
//  ViewController.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 02/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let fmgr = FileManager.default
    private let docDir = NSHomeDirectory() + "/Documents"
    private var photoDir:String?
    
    private var myData:Array<[String:AnyObject]> = []
    
    @IBAction func backHere( segue: UIStoryboardSegue ) {
        print("back home")
    }
    
    
    @IBAction func refreshData(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let infoVC = storyboard?.instantiateViewController(withIdentifier: "stayInfo") {
            
            show( infoVC, sender: self)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell" ) as! CustomTableViewCell
//        let photoPath_str = myData[indexPath.row]["photpPath"] as! String
        let photoPath_str = photoDir! + "/" + ( myData[indexPath.row]["ID"] as! String ) + ".jpg"
        
        if fmgr.fileExists(atPath: photoPath_str) {
            
            cell.img.image = UIImage(contentsOfFile: photoPath_str)

        } else {
            
            cell.img.image = UIImage(named: "none.png")

        }

        
        cell.title.text = self.myData[indexPath.row]["Name"] as! String
        cell.address.text = self.myData[indexPath.row]["Address"] as! String

 
        return cell
        
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
    
    @IBAction func getJSON(_ sender: Any) {
        
        do {
            let url = URL( string: "http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelStay.aspx" )
            let data = try Data(contentsOf: url!)
            
            parseJSON( json: data)
            
        } catch {
            print(error)
        }
    }
    
    private func parseJSON( json: Data ) {
//        print("parseJSON(): OK")
        
        do {
            if let jsonObj = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) {
                
                myData = []
                
                let allObj = jsonObj as! [[String:AnyObject]]
                print(allObj.count)
                
                for row in allObj {
                    
                    DispatchQueue.global().async {
                        for (key,val) in row {
                            print("\(key) : \(val)")
                            
                        }
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        self.initStat()
                        self.myData += [row]
                        
                        do {
                            
                            let photoURL_str = row["Photo"] as! String
                            let photoPath_str = self.photoDir! + "/" + ( row["ID"] as! String ) + ".jpg"
                            
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
        
        print(docDir)
        initStat()
        getJSON(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

