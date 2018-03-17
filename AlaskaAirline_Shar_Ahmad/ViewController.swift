//
//  ViewController.swift
//  AlaskaAirline_Shar_Ahmad
//
//  Created by Sheheryar Ahmad on 3/16/18.
//  Copyright © 2018 Sheheryar Ahmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var finalData:Array<FlightRecord> = []
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    
    
    @IBOutlet weak var airportCode: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        if(self.airportCode.text?.characters.count == 3){
            PlistManager.sharedInstance.saveValue(value: self.airportCode.text as AnyObject, forKey: "airportCode")
        }else{
            let alertCt = UIAlertController(title: "Alert", message: "Enter The AirPort Code Correctly", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) in
                alertCt.dismiss(animated: true, completion: nil)
            })
            
            alertCt.addAction(alertAction)
            present(alertCt, animated: true, completion: nil)
            
        }
        
        let fetchObject = ListManager()
        let airportThreeCode:String = self.airportCode.text!
        
        fetchObject.fetchFlightsRecordsWithUrl(flightCode: airportThreeCode as String) { (allFlightRecords, error) in
            if let flightData = allFlightRecords{
                self.finalData = flightData as! Array<FlightRecord>
                self.saveData(recordArray: self.finalData)
                self.tableView.reloadData()
                
            }
        }
    }
        private func saveData(recordArray: [FlightRecord]){
            
            NSKeyedArchiver.archiveRootObject(recordArray, toFile: filePath)
            
        }
        
        private func loadData(){
            
            if let overData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [FlightRecord]{
                finalData = overData
            }
            
        }
        

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.finalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let cellData = self.finalData[indexPath.row]
        

    
        cell.textLabel?.text = "\(cellData.flightCode)"+" "+"\(cellData.airportCode)"+" " + "\(cellData.arrivalTime)"
        
        return cell
        
    }
}

