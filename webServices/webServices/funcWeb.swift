//
//  funcWeb.swift
//  webServices
//
//  Created by Andres Abraham Bonilla Gòmez on 24/07/18.
//  Copyright © 2018 beHere. All rights reserved.
//

import Foundation
import Alamofire


class funcWeb
{
    var nameCountryArray: Array<String> = []
    var codeCountryArray: Array<String> = []
    var urlCountryArray: String = ""
    var typeInputCountryArray: String = ""
    
    var flag = false
        
    func verifyData(url :String , completion: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: NSURL.init(string: url)! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5 // 10 secs
        
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result
            {
            case .success( _):
                if let JSON = response.result.value
                {
                    let dicJSON = JSON as! NSDictionary
                    if dicJSON.value(forKey: "success") as! Int == 1
                    {
                        self.flag = true
                        completion(self.flag)
                    }
                }
            case .failure( _):
                self.flag = false
                completion(self.flag)
            }
            
        }

    }

    func dataCountries(url :String , completion: @escaping (Bool) -> ())
    {
        Alamofire.request(url) .responseJSON { response in
            if let JSON = response.result.value
            {
                let dicJSON = JSON as! NSDictionary
                let dicJSONData = dicJSON.value(forKey: "data") as! NSDictionary
                let dicJSONCountry = dicJSONData.value(forKey: "countries") as! NSArray
                for item in dicJSONCountry as! [NSDictionary]
                {
                    //5.
                    let name = item["name"] as? String ?? ""
                    let code = item["code"] as? String ?? ""
                    self.nameCountryArray.append(name)
                    self.codeCountryArray.append(code)
                }
                completion(true)
            }
        }
        
    }
    
    func dataForCountry(url :String , completion: @escaping (Bool) -> ())
    {
        Alamofire.request(url) .responseJSON{ response in
            if let JSON = response.result.value
            {
                let dicJSON = JSON as! NSDictionary
                let dicJSONData = dicJSON.value(forKey: "data") as! NSDictionary
                let dicJSONDataCountry = dicJSONData.value(forKey: "identification") as! NSDictionary
                let urlCountry = dicJSONDataCountry.value(forKey: "help_url") ?? "No hay URL"
                let typeEntry = dicJSONDataCountry.value(forKey: "input_type") ?? "False"
                self.urlCountryArray = urlCountry as! String
                self.typeInputCountryArray = typeEntry as! String
                completion(true)
            }
        }
    }
}
