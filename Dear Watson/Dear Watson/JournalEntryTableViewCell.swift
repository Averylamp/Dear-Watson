//
//  JournalEntryTableViewCell.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

enum Emotions {
    case Joy
    case Sadness
    case Fear
    case Disgust
    case Anger
    func emotionToString()-> String{
        switch self {
        case .Joy:
            return "Joy"
        case .Sadness:
            return "Sadness"
        case .Fear:
            return "Fear"
        case .Disgust:
            return "Disgust"
        case .Anger:
            return "Anger"
        }
    }
}

extension String{
    func stringToEmotion() ->Emotions{
        switch self {
        case "Joy":
            return Emotions.Joy
        case "Sadness":
            return Emotions.Sadness
        case "Fear":
            return Emotions.Fear
        case "Disgust":
            return Emotions.Disgust
        case "Anger":
            return Emotions.Anger
        default:
            return Emotions.Joy
        }
    }
}

class JournalEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var journalDateLabel: UILabel!
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setEmotionsLabel(emotions: [[Any]]){
        var text = "Emotion : "
        var count = 0
        let sortedEmotions = emotions.sorted { (first, second) -> Bool in
            return (first[1] as! Double) > (second[1] as! Double)
        }
        for item in sortedEmotions {
            let emotion = item[0] as! String
            let emotionValue = item[1] as! Double * 100
            switch emotion {
            case Emotions.Joy.emotionToString():
                text += "\(joyfulFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Fear.emotionToString():
                text += "\(fearfulFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Anger.emotionToString():
                text += "\(angryFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Disgust.emotionToString():
                text += "\(disgustedFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Sadness.emotionToString():
                text += "\(sadFace) \(String(format: "%.1f", emotionValue)), "
            default:
                print("Case not found")
            }
            count += 1
        }
        self.emotionLabel.text = text
    }
    
}
