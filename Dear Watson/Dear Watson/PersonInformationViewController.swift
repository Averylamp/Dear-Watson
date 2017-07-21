//
//  PersonInformationViewController.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Charts

class PersonInformationViewController: UIViewController {
    
    var joyfulData:[Double] = [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263]
    var sadData:[Double] = [0.41, 0.753, 0.4236,0.2135,0.952,0.2519,0.81263]
    var angerData:[Double] = [0.01, 0.253, 0.11,0.7135,0.952,0.2519,0.81263]
    var disgustedData:[Double] = [0.01, 0.253, 0.4236,0.2135,0.952,0.7519,0.81263]
    var fearData:[Double] = [0.01, 0.653, 0.1236,0.2135,0.252,0.2519,0.81263]
    
    var scrollView = UIScrollView()
    
    var titleLabel = UILabel()
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: put in storyboard
        titleLabel.frame = CGRect(x: 40, y: 10, width: self.view.frame.width - 80, height: 90)
        titleLabel.text = "Historical Data"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Avenir-Medium", size: 36)
        self.view.addSubview(titleLabel)
        
        
        scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.view.addSubview(self.scrollView)
        
        
        
    }
    
    func initializeCharts(){
        let graphWidth = self.view.frame.width * 0.9
        let graphHeight = self.view.frame.height * 0.4
        
        let x = self.view.frame.width * 0.05
        var y = CGFloat(10)
        
        let titleHeight = self.view.frame.width * 0.2
        let titleWidth = self.view.frame.width
        
        let margin = CGFloat(20)
        
        
        // Happy
        self.addChart(titleFrame: CGRect( x:50, y: y, width: titleWidth - 100, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [joyfulData], chartTitle: [joyfulFace], colors: [NSUIColor.yellow])
        
        y = y + titleHeight + graphHeight + margin
        
        // Sad
        self.addChart(titleFrame: CGRect(x:50, y: y, width: titleWidth - 100, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [sadData], chartTitle: [sadFace], colors: [UIColor.blue])
        
        y = y + titleHeight + graphHeight + margin
        
        // Disgust
        self.addChart(titleFrame: CGRect(x:50, y: y, width: titleWidth - 100, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [disgustedData], chartTitle: [disgustedFace], colors: [UIColor.green])
        
        y = y + titleHeight + graphHeight + margin
        
        // Fear
        self.addChart(titleFrame: CGRect(x:50, y: y, width: titleWidth - 100, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [fearData], chartTitle: [fearfulFace], colors: [UIColor.purple])
        
        y = y + titleHeight + graphHeight + margin
        
        // Anger
        self.addChart(titleFrame: CGRect(x:50, y: y, width: titleWidth - 100, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [angerData], chartTitle: [angryFace], colors: [UIColor.red])
        
        y = y + titleHeight + graphHeight + margin
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: y+50)
        
    }
    
    func addChart(titleFrame: CGRect, chartFrame:CGRect, dataPoints:[[Double]], chartTitle:[String], colors: [NSUIColor]){
        
        let title = UILabel(frame: titleFrame)
        title.text = chartTitle[0]
        title.textAlignment = .center
        title.font = title.font.withSize(150)
        self.scrollView.addSubview(title)
        
        
        let chart = LineChartView(frame: chartFrame)
        
        var allDataSets = LineChartData()
        var count = 0
        var dataEntries = [ChartDataEntry]()
        for dataSet in dataPoints {
            for i in 0..<dataSet.count{
                let dataEntry = ChartDataEntry(x: 10 * Double(i), y: dataSet[i])
                dataEntries.append(dataEntry)
                
            }
            
            let dataset = LineChartDataSet(values: dataEntries, label: nil)
            dataset.label = chartTitle[count]
            
            switch chartTitle[0] {
            case joyfulFace:
                dataset.label =  dataset.label! + " Joy"
            case sadFace:
                dataset.label =  dataset.label! + " Sadness"
            case fearfulFace:
                dataset.label =  dataset.label! + " Fear"
            case disgustedFace:
                dataset.label =  dataset.label! + " Disgust"
            case angryFace:
                dataset.label =  dataset.label! + " Anger"
            default:
                dataset.label =  dataset.label! + " Joy"
            }
            dataset.circleRadius  = 5
            dataset.mode = .horizontalBezier
            dataset.lineWidth = 4
            
//            dataset.setColor(UIColor.blue)
//            if count > 2{
//                dataset.setColor(UIColor.green)
//                dataset.fillColor = UIColor.orange
//                dataset.highlightColor = UIColor.orange
//                dataset.setCircleColors(UIColor.darkGray)
//            }
//            dataset.colors = colors
            print(count)
            dataset.setColors([colors.first!], alpha: 1.0)
//            dataset.setColor(colors[count])
            dataset.setCircleColor(UIColor.black)
            allDataSets.addDataSet(dataset)
            count += 1
        }
//        chart.animate(yAxisDuration: 2.0)
//       count = 0
//        for set in allDataSets{
//            set.setColor(colors[count])
//            count += 1
//        }
//        chart.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.easeOutExpo)
//        chart.animate(xAxisDuration: 2.0)
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeOutQuad)
        
        print(chart.lineData?.getColors())
        chart.data = allDataSets
        
        self.scrollView.addSubview(chart)
        
        
    }
    
}
