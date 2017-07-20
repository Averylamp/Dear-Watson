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

    func setEmotionsLabel(emotionOrdering: [Emotions], emotionPercent:[Double]){
        var text = "Emotion : "
        var count = 0
        
        for emotion in emotionOrdering{
            switch emotion {
            case .Joy:
                text += "\(joyfulFace) (\(String(format: "%.1f", emotionPercent[count]))%), "
            case .Fear:
                text += "\(fearfulFace) (\(String(format: "%.1f", emotionPercent[count]))%), "
            case .Anger:
                text += "\(angryFace) (\(String(format: "%.1f", emotionPercent[count]))%), "
            case .Disgust:
                text += "\(disgustedFace) (\(String(format: "%.1f", emotionPercent[count]))%), "
            case .Sadness:
                text += "\(sadFace) (\(String(format: "%.1f", emotionPercent[count]))%), "
            default:
                print("Case not found")
            }
            count += 1
        }
        self.emotionLabel.text = text
    }
    
}
