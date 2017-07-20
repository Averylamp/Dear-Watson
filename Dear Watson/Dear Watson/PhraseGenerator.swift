//
//  PhraseGeneration.swift
//  Dear Watson
//
//  Created by Avery Lamp on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import Foundation

class PhraseGeneration {
    
    let GREETING = [
        "How are you today?",
        "Hi, how are you doing today?",
        "What's up?"
    ]
    
    let FOLLOWUP = [
        "What did you do today?",
        "Did you do anything interesting today?"
    ]
    
    let HAPPY_RESPONSE = [
        "That sounds great! Is there anything else you want to tell me about?",
        "Awesome! Anything else cool happen?",
        "Cool!"
    ]
    
    let SAD_RESPONSE = [
        "Aw, I'm sorry to hear that. Want to tell me more about it?",
        "That sounds unfortunate. Would you like to tell me more about it?"
    ]
    
    let DISGUSTED_RESPONSE = [
        "Oh, gross. Sorry to hear that."
    ]
    
    let FEAR_RESPONSE = [
        "Oh no. Will everything be okay?"
    ]
    
    let ANGRY_RESPONSE = [
        "That really sucks. Want to tell me more about it?"
    ]
    
    
    func getGreeting() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(GREETING.count)))
        
        return GREETING[randomIndex]
    }
    
    func getFollowup() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(FOLLOWUP.count)))
        
        return FOLLOWUP[randomIndex]
    }
    
    func getHappyResponse() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(HAPPY_RESPONSE.count)))
        
        return HAPPY_RESPONSE[randomIndex]
    }
    
    func getSadResponse() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(SAD_RESPONSE.count)))
        
        return SAD_RESPONSE[randomIndex]
    }
    
    func getDisgustedResponse() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(DISGUSTED_RESPONSE.count)))
        
        return DISGUSTED_RESPONSE[randomIndex]
    }
    
    func getFearResponse() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(FEAR_RESPONSE.count)))
        
        return FEAR_RESPONSE[randomIndex]
    }
    
    func getAngryResponse() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(ANGRY_RESPONSE.count)))
        
        return ANGRY_RESPONSE[randomIndex]
    }
    
}
