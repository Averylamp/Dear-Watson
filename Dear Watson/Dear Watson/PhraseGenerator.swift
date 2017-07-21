//
//  PhraseGeneration.swift
//  Dear Watson
//
//  Created by Avery Lamp on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import Foundation

class PhraseGeneration {
    static let sharedInstance = PhraseGeneration()

    let GREETING = [
        "How are you today?  Did you do anything interesting?",
        "Hi, how are you doing today?  What did you do?",
        "What's up?  Did you do anything cool today?",
        "How's life?  Anything happen today?"
    ]
    
    let FOLLOWUP = [
        "What else did you do today? Did you want to elaborate?",
        "Did you do anything else today?  Meet anyone?",
        "Did you meet anyone today as well or hang out with anyone?"
    ]
    
    let HAPPY_RESPONSE = [
        "That sounds great! Is there anything else you want to tell me about?",
        "Awesome! Anything else cool happen today?",
        "Cool! Anything else new today?"
    ]
    
    let SAD_RESPONSE = [
        "Aw, I'm sorry to hear that. Want to tell me more about it?",
        "That sounds unfortunate. Would you like to tell me more about it?"
    ]
    
    let DISGUSTED_RESPONSE = [
        "Oh, gross. Sorry to hear that. I hope something nicer happened today?",
        "That stinks. Really sorry to hear that. Did anything nicer happen today?"
    ]
    
    let FEAR_RESPONSE = [
        "Oh no. Will everything be okay?"
    ]
    
    let ANGRY_RESPONSE = [
        "Wow, I'm sorry to hear that. Want to vent to me about it?",
        "That really sucks. Want to tell me more about it?"
    ]
    
    let EMOTIONAL_FOLLOWUP = [
        "Well thats good to hear.  Tell my any one last thing",
        "That's great to hear.  Tell my any one last thing",
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
    
    func getEmotionalFollowup() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(EMOTIONAL_FOLLOWUP.count)))
        
        return EMOTIONAL_FOLLOWUP[randomIndex]
    }
}
