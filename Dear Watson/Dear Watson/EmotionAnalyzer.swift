//
//  EmotionAnalyzer.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EmotionAnalyzer: NSObject {
    static let sharedInstance = EmotionAnalyzer()
    
    func emotionsFrom(text:String, completion: @escaping ([[String:Any]])->Void){
        Alamofire.request("https://openwhisk.ng.bluemix.net/api/v1/web/Blue%20Hack%20NA%202017_Pengwings/default/emotions.json", method: .post, parameters:["text":text], headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json["emotions"].array)")
                if let emotionsArr = json["emotions"].arrayObject, let response = emotionsArr as? [[String:Any]]{
                    completion(response)
                }
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func keywordsFrom(text:String,  completion: @escaping ([[String:Any]])->Void){
        let params:[String:Any] = ["text":text,"limit":"5"]
        let headers:[String:Any] = ["Content-Type":"application/json"]
        print(params)
        Alamofire.request("https://openwhisk.ng.bluemix.net/api/v1/web/Blue%20Hack%20NA%202017_Pengwings/default/keywords.json", method: .post, parameters:["text":"Hello my name is Avery Lamp.  I like ice cream and other things like coding and eating food."], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json["keywords"].array)")
                if let keywordsArr = json["keywords"].arrayObject, let response = keywordsArr as? [[String:Any]]{
                    completion(response)
                }
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }

}
