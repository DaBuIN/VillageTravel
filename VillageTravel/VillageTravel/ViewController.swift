//
//  ViewController.swift
//  VillageTravel
//
//  Created by Chuei-Ching Chiou on 02/07/2017.
//  Copyright © 2017 MESA07. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
        print("parseJSON(): OK")
        
        do {
            if let jsonObj = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) {
                
                let allObj = jsonObj as! [[String:AnyObject]]
                print(allObj.count)
                
                for row in allObj {
                    for (key,val) in row {
                        print("\(key) : \(val)")
                    }
                }
            }
            
            
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

