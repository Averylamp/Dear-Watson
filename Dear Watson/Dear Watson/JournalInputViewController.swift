//
//  JournalInputViewController.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LTMorphingLabel


struct journalEntryKeys {
    static let journalStoreKey = "JournalStoreKey"
    static let dateKey = "date"
    static let fullTextKey = "fullText"
    static let emotionKey = "emotions"
    static let keywordsKey = "keywords"
    static let journalTitleKey = "journalTitle"
}



let joyfulFace = "😀"
let sadFace = "😢"
let disgustedFace = "🙄"
let fearfulFace = "😨"
let angryFace = "😡"
let smileyFace = "😁"

enum ConversationState {
    case generalQuestion
    case generalFollowUpQuestion
    case emotionalQuestion
    case emotionalFollowup
    case finishedQuestioning
}

class JournalInputViewController: UIViewController {
    var synth = AVSpeechSynthesizer()

    @IBOutlet weak var responseTextView: UITextView!
    var appleSpeechAnalyzer =  AppleSpeechController()
    var speechActive = false

    var conversationState:ConversationState = .generalQuestion

    @IBOutlet weak var questionLabel: LTMorphingLabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var faceLabel: UILabel!

    //sadness, joy,fear, anger, disgust

    var temporaryText = ""
    var fullText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        appleSpeechAnalyzer = AppleSpeechController()
        appleSpeechAnalyzer.delegate = self
        appleSpeechAnalyzer.setupRecognizer()
        questionLabel.text = ""
        questionLabel.morphingEffect = .fall
        questionLabel.morphingDuration = 1.0
        questionLabel.morphingCharacterDelay = 0.02
        self.responseTextView.text = "I'm doing pretty well.  Today I went to Chipotle for dinner and I ate a really tasty burrito bowl.  I also went home and took a nap afterwards which was refreshing.  Before that though, I hung out with a friend and we watched some TV shows. \n\nIt was pretty fun.  I also worked at the office and hung out with some interns."
        self.delay(delay: 1.0) {
            self.conversationState = .generalFollowUpQuestion
            let question = PhraseGeneration.sharedInstance.getGreeting()
            self.askQuestion(question: question)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        saveInformation()
    }
    let mockEntries = [
      "Today I went on a walk with my dog and I saw ducklings! They were really cute and my dog was really excited. But later on I walked near some goslings and a goose attacked me. My dog protected me though. Overall a pretty good day though. The goslings were pretty cute. Also my dog popped a animal balloon and some kid cried but it was kind of funny.", "Today at work we had a hackathon! Xcode didn't download for like forever. While we were waiting we watched Up. I cried when the wife died. I cried when all the balloons started crying but I also started happy crying when the balloons lifted his house into Paradise Falls. ", "Today a lot of people entered our hackathon room. It was kind of annoying. Grace tried to write on the wall but she did it on the wrong side so she had to write backwards and it was cool. I got a Starbucks and I was disappointed at the size to price ratio. Also some guy spilled yogurt on the ground. It was pretty gross. Also some random dude was carrying happy birthday balloons in the Starbucks. They were really big.","Today I learned how to make a balloon animal. I made a snake! I heard on the news that some rude guy was going around the neighborhood dropping sausages with razors inside. I can't let my dog eat food off the ground now. I was pretty angry to hear that and I hope the dude gets caught and sentenced to a million years in prison. "
    ]
    
    func saveInformation(){
        self.stopAppleSTT()
        let defaults = UserDefaults.standard
        var fullAllEntries = [[String:Any]]()
        if let allEntries = defaults.array(forKey: journalEntryKeys.journalStoreKey), let formattedAllEntries = allEntries as? [[String:Any]] {
            fullAllEntries = formattedAllEntries
        }else{
            var count = 0
            for item in mockEntries{
                count += 1
                createJournalEntry(string: item, count: count + 1, callback: { (response) in
                    var modresponse = response
                    modresponse[journalEntryKeys.journalTitleKey] = "Journal Entry \(fullAllEntries.count + 1)"
                    fullAllEntries.append(modresponse)
                    count -= 1
                    if count == 0{
                        defaults.set(fullAllEntries, forKey: journalEntryKeys.journalStoreKey)
                        self.saveInformation()
                    }
                })
            }
            return
        }
        createJournalEntry(string: self.responseTextView.text, count: fullAllEntries.count + 1) { (journalEntry) in
            fullAllEntries.append(journalEntry)
            print(fullAllEntries)
            defaults.set(fullAllEntries, forKey: journalEntryKeys.journalStoreKey)
            self.delay(delay: 0.0, closure: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func createJournalEntry(string: String, count: Int = 1, callback: @escaping ([String:Any])-> Void ){
        var journalEntry = [String:Any]()
        journalEntry[journalEntryKeys.journalTitleKey] = "Journal Entry \(count)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM H:mm a yyyy"
        journalEntry[journalEntryKeys.dateKey] = dateFormatter.string(from: Date())
        journalEntry[journalEntryKeys.fullTextKey] = string
        var count = 2
        EmotionAnalyzer.sharedInstance.keywordsFrom(text: string) { (response) in
            count -= 1
            let keywordResponse = EmotionAnalyzer.sharedInstance.processKeywords(result: response)
            journalEntry[journalEntryKeys.keywordsKey] = keywordResponse
            if count == 0{
                callback(journalEntry)
            }
        }
        EmotionAnalyzer.sharedInstance.emotionsFrom(text: string) { (response) in
            count -= 1
            let emotions = EmotionAnalyzer.sharedInstance.processEmotions(emotions: response)
            var emotionCoverted = [[Any]]()
            for (emotion, value) in emotions{
                emotionCoverted.append([emotion.emotionToString(), value])
            }
            journalEntry[journalEntryKeys.emotionKey] = emotionCoverted
            if count == 0{
                callback(journalEntry)
            }
        }
    }



    @IBAction func nextQuestionClicked(_ sender: Any) {
        var question = ""
        switch self.conversationState {
        case .generalQuestion:
            question = PhraseGeneration.sharedInstance.getGreeting()
            self.conversationState = .generalFollowUpQuestion
            self.askQuestion(question:question)
            self.delay(delay: 0.3) {
                self.responseTextView.text = self.responseTextView.text + "\n\n"
                self.fullText = self.responseTextView.text
            }
        case .generalFollowUpQuestion:
            print("General Followup")
            question = PhraseGeneration.sharedInstance.getFollowup()
            self.conversationState = .emotionalQuestion
            self.askQuestion(question:question)
            self.delay(delay: 0.3) {
                self.responseTextView.text = self.responseTextView.text + "\n\n"
                self.fullText = self.responseTextView.text
            }
        case .emotionalQuestion:
            print("Emotional Question")
            EmotionAnalyzer.sharedInstance.emotionsFrom(text: self.responseTextView.text, completion: { (results) in
                print(results)
                if let topResult = results.first!["tone_id"] as? String {
                    print(topResult)
                    let processedResults = EmotionAnalyzer.sharedInstance.processEmotions(emotions: results)
                    switch topResult {
                    case "joy":
                        question  = PhraseGeneration.sharedInstance.getHappyResponse()
                    case "fear":
                        question  = PhraseGeneration.sharedInstance.getFearResponse()
                    case "disgust":
                        question  = PhraseGeneration.sharedInstance.getDisgustedResponse()
                    case "sadness":
                        question  = PhraseGeneration.sharedInstance.getSadResponse()
                    case "anger":
                        question  = PhraseGeneration.sharedInstance.getAngryResponse()
                    default:
                        print("Unknown emotion sent back")
                        question  = PhraseGeneration.sharedInstance.getHappyResponse()
                    }
                    self.delay(delay: 0.0, closure: {
                        self.askQuestion(question:question)
                    })
                    self.delay(delay: 0.3) {
                        self.responseTextView.text = self.responseTextView.text + "\n\n"
                        self.fullText = self.responseTextView.text
                    }
                    self.conversationState = .emotionalFollowup
                }
            })
        case .emotionalFollowup:
            print("Emotional Followup")
            question = PhraseGeneration.sharedInstance.getEmotionalFollowup()
            self.conversationState = .finishedQuestioning
            self.askQuestion(question:question)
            self.delay(delay: 0.3) {
                self.responseTextView.text = self.responseTextView.text + "\n\n"
                self.fullText = self.responseTextView.text
            }
        case .finishedQuestioning:
            print("Finished questioning")
            backButtonClicked(UIButton())
        }


    }

    @IBAction func recordButtonClicked(_ sender: Any) {
        self.toggleAppleSTT()
    }

    func askQuestion(question:String){
        self.stopAppleSTT()
        speakResponse(text: question)
        questionLabel.text = question
        delay(delay: 3.5) {
            self.startAppleSTT()
        }
    }

    let buttonTransitionAnimationTime = 0.5
    func speakResponse(text:String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        utterance.volume = 1.0
        self.synth.speak(utterance)
        faceLabel.growAndShrink(duration: 3.0, times: 6)
        faceLabel.shake(duration: 3.0)
        faceLabel.rotate(duration: 3.0, times: 10)
    }
}

extension JournalInputViewController: AppleSpeechFeedbackProtocall{

    func toggleAppleSTT(){
        if appleSpeechAnalyzer.isRecording(){
            stopAppleSTT()
        }else{
            startAppleSTT()
        }
    }


    func stopAppleSTT(){
        if appleSpeechAnalyzer.isRecording(){
            appleSpeechAnalyzer.recordButtonTapped()
            UIView.transition(with: recordButton, duration: buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "MicButton"), for: .normal)
            },completion: nil)
            speechActive = false
        }
    }

    func startAppleSTT(){
        if appleSpeechAnalyzer.isRecording() == false{
            appleSpeechAnalyzer.recordButtonTapped()
            UIView.transition(with: recordButton, duration: buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            },completion: nil)
            speechActive = true
        }
    }

    func finalAppleRecognitionRecieved(phrase: String) {
        temporaryText = ""
        self.responseTextView.text = fullText + phrase + ".  "
        fullText = self.responseTextView.text
        DispatchQueue.main.async {
            UIView.transition(with: self.recordButton, duration: self.buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "MicButton"), for: .normal)
            },completion: nil)
        }
    }

    func partialAppleRecognitionRecieved(phrase: String) {
        temporaryText = phrase
        self.responseTextView.text = fullText + temporaryText
    }

    func errorAppleRecieved(error: String) {
        print("ERROR RECORDING \(error)")
    }


}


extension UIView {
    func shake(duration: Double) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]

        layer.add(animation, forKey: "shake")
    }

    func growAndShrink(duration: Double, times: Int) {
        let xAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        xAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        xAnimation.duration = duration
        var values:[Double] = [Double]()
        for i in 0..<times{
            values.append(1.02 + Double(arc4random_uniform(10) + 5) / 100.0)
            values.append(0.98 - Double(arc4random_uniform(10) + 5) / 100.0)
        }
        values.append(1.0)
        xAnimation.values = values
        layer.add(xAnimation, forKey: "scale_x")
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        yAnimation.values = values
        layer.add(yAnimation, forKey: "scale_y")

    }

    func rotate(duration:Double, times: Int){
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotationAnimation.isAdditive = true
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(M_PI_4 / 10)
            values.append(-M_PI_4 / 10)
        }
        values.append(0)
        rotationAnimation.values = values
        layer.add(rotationAnimation, forKey: "rotate")
    }

    func bounce(duration: Double, times: Int) {
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(10)
            values.append(-10)
        }
        yAnimation.values = values
        layer.add(yAnimation, forKey: "bounce")
    }

    func spin(duration:Double, times:Int){
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(10)
           values.append(-2)
        }
        yAnimation.values = values
        layer.add(yAnimation, forKey: "rotate_x")
    }
}
