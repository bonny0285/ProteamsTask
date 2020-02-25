//
//  LocationsModel.swift
//  ProteamsTask
//
//  Created by Massimiliano on 25/01/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol GetDataDelegate{
    func getLocationsArray(data: [LocationsItem])
}


struct LocationsModel{
    
    
    
    var delegate: GetDataDelegate?
    
    var par = ["latitudeNorth":"51.54126776718752", "latitudeSouth":"51.48964361688991", "longitudeEast":"-0.1391464811950982", "longitudeWest":"-0.1890868820194953"]
    
   
    
    func getData(parameters: [String : String] = ["latitudeNorth":"51.54126776718752", "latitudeSouth":"51.48964361688991", "longitudeEast":"-0.1391464811950982", "longitudeWest":"-0.1890868820194953"]){
        print(#function)
            let url = URL(string: "https://ukschools.guide:4000/map-demo")
            
            let encoding = JSONEncoding.default
            Alamofire.request(url!, method: .post,parameters: parameters,encoding: encoding).responseJSON { (response) in
                
                switch response.result{
                    
                case .success(let value):
                    let json = JSON(value)
                   
                    DispatchQueue.main.async {
                        self.delegate?.getLocationsArray(data: self.parseJSON(data: json))
                    }
                        
 
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
     func parseJSON(data: JSON) -> [LocationsItem]{
        var locationsItem: LocationsItem?
        var arrayLocationsItem = [LocationsItem]()
        
        var counter = 0
        data.forEach({_ in
            counter += 1
        })
        
        for i in 0 ... counter - 1 {
            let name = data[i]["school_name"]
            print(name)
            let latitude = data[i]["latitude"]
            let longitude = data[i]["longitude"]
            locationsItem = LocationsItem(latitude: "\(latitude)", longitude: "\(longitude)", SchoolName: "\(name)")
            arrayLocationsItem.append(locationsItem!)
        }
        
        return arrayLocationsItem
    }
    
    
}
