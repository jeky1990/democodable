//
//  ViewController.swift
//  demoCodableSwift
//
//  Created by macbook on 10/01/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var instruction : String = ""
    var endarray : [Any] = []
    var minusDistance = 50
    var fixdis = 50
    var lengths : [Int] = []
    var i1 : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let a_cordinate_strting = "23.118909,72.572291"
        let b_cordinate_strting = "23.117473,72.628734"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_cordinate_strting)&destination=\(b_cordinate_strting)&key=AIzaSyBVy-Z7jzqcPEmWsfJS0m60-tZWQTndYl4"
        
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        let configure = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configure)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, responce, error) in
            
            do{
                guard let data = data else{
                    return
                }
                
                let jsondeocder = JSONDecoder()
                let responceModel = try jsondeocder.decode(Json4Swift_Base.self, from: data)
                
                if responceModel.status == "OK"
                {
                    let routes = responceModel.routes!
                    let legs = routes[0].legs!
                    let steps = legs[0].steps!
                    
                    for i in 0..<steps.count
                    {
                        let singleSteps = steps[i]
                        let start = singleSteps.start_location!
                        let endLat = start.lat!
                        let endlong = start.lng!
                        let value = singleSteps.distance!.value!
                        if singleSteps.maneuver != nil
                        {
                            let maneuver =  singleSteps.maneuver!
                            self.instruction = maneuver
                        }
                        
                        let enddic = ["endlat": endLat as Any,"endlong":endlong as Any,"distance":value,"maneuver":self.instruction] as [String : Any]
                        self.endarray.append(enddic)
                        print(enddic)
                    }
                    
                    self.GetDistanceOnlengthOnArray()
                    print(self.lengths)
                    self.CompareValue()
                    
                }
                else
                {
                    print(error?.localizedDescription as Any)
                }
                
                
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    func GetDistanceOnlengthOnArray()
    {
        for i in 0..<endarray.count
        {
            let dic = endarray[i] as! [String:Any]
            let distance = dic["distance"] as! Int
            let distance1 = distance - minusDistance
            if minusDistance == 100
            {
                minusDistance = 100
            }
            else
            {
                minusDistance += 50
            }
            lengths.append(distance1)
            lengths.append(fixdis)
        }
    }
    
    func CompareValue()
    {
        for _ in 0..<endarray.count
        {
            let dic = endarray[i1] as! [String:Any]
            let lat = dic["endlat"] as! Double
            let long = dic["endlong"] as! Double
            let distance = dic["distance"] as! Int
            let instruction1 = dic["maneuver"] as! String
            print("\(lat),\(long),\(distance),\(instruction1)")
        }
    }
    
}



