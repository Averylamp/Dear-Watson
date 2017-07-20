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

    var happyData = [Double]()
    var sadData = [Double]()
    var angerData = [Double]()
    
    var scrollView = UIScrollView()
    
    var titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.frame = CGRect(x: 20, y: 0, width: self.view.frame.width, height: 100)
        titleLabel.text = "Historical Data"
        self.view.addSubview(titleLabel)
        
        
        scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
        self.view.addSubview(self.scrollView)
        
        
        // Happy
        self.addChart(titleFrame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 10), chartFrame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 200), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😁", color: UIColor.magenta)
        
        // Sad
        self.addChart(titleFrame: CGRect(x: 10, y: 310, width: self.view.frame.width, height: 10), chartFrame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 200), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😢", color: UIColor.blue)
        
        // Anger
        self.addChart(titleFrame: CGRect(x: 10, y: 610, width: self.view.frame.width, height: 10), chartFrame: CGRect(x: 0, y: 600, width: self.view.frame.width, height: 200), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😡", color: UIColor.red)
        
    }
    
    func addChart(titleFrame: CGRect, chartFrame:CGRect, dataPoints:[Double], chartTitle:String, color: UIColor){
        
        let title = UILabel(frame: titleFrame)
        title.text = chartTitle
        title.font = title.font.withSize(20)
        self.scrollView.addSubview(title)
        
        
        let chart = LineChartView(frame: chartFrame)
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count{
            
            let dataEntry = ChartDataEntry(x: 10 * Double(i), y: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let dataset = LineChartDataSet(values: dataEntries, label: nil)
        dataset.label = nil
        dataset.circleRadius  = 4
        dataset.mode = .horizontalBezier
        dataset.lineWidth = 2
        dataset.setColor(color)
        dataset.setCircleColor(color)
        
        chart.data = ChartData(dataSet: dataset)
        
        chart.chartDescription = nil
        
        var dataSets = [IChartDataSet]()
        dataSets.append(dataset)
        chart.data = LineChartData(dataSet: dataset)
        self.scrollView.addSubview(chart)
        
    }
    
}
