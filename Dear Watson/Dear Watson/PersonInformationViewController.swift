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
        
        // TODO: put in storyboard
        titleLabel.frame = CGRect(x: 20, y: 10, width: self.view.frame.width, height: 90)
        titleLabel.text = "Historical Data"
        titleLabel.font = titleLabel.font.withSize(self.view.frame.width * 0.1)
        self.view.addSubview(titleLabel)
        
        
        scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
        self.view.addSubview(self.scrollView)
        
        
        let graphWidth = self.view.frame.width * 0.9
        let graphHeight = self.view.frame.height * 0.4
        
        let x = self.view.frame.width * 0.05
        var y = CGFloat(10)
        
        let titleHeight = self.view.frame.width * 0.2
        let titleWidth = self.view.frame.width * 0.2
        
        let margin = CGFloat(20)
        
        // Happy
        self.addChart(titleFrame: CGRect(x: (self.view.frame.width/2)-x, y: y, width: titleWidth, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😁", color: UIColor.magenta)
        
        y = y + titleHeight + graphHeight + margin
        
        // Sad
        self.addChart(titleFrame: CGRect(x: (self.view.frame.width/2)-x, y: y, width: titleWidth, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😢", color: UIColor.blue)
        
        y = y + titleHeight + graphHeight + margin
        
        // Anger
        self.addChart(titleFrame: CGRect(x: (self.view.frame.width/2)-x, y: y, width: titleWidth, height: titleHeight), chartFrame: CGRect(x: x, y: y + titleHeight, width: graphWidth, height: graphHeight), dataPoints: [0.01, 0.253, 0.1236,0.2135,0.952,0.2519,0.81263], chartTitle: "😡", color: UIColor.red)
        
        y = y + titleHeight + graphHeight + margin
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: y+50)
        
    }
    
    func addChart(titleFrame: CGRect, chartFrame:CGRect, dataPoints:[Double], chartTitle:String, color: UIColor){
        
        let title = UILabel(frame: titleFrame)
        title.text = chartTitle
        title.font = title.font.withSize(self.view.frame.width * 0.1)
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
