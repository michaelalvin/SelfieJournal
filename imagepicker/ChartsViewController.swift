//
//  ChartsViewController.swift
//  imagepicker
//
//  Created by Michael Alvin on 1/17/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    
    var numbers : [Double] = [] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    @IBOutlet weak var lineChart: LineChartView!
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number of Happy Moments") //Here we convert lineChartEntry to a LineChartDataSet
        let data = LineChartData() //This is the object that will be added to the chart
        
        data.addDataSet(line1) //Adds the line to the dataSet
        data.setDrawValues(true)
        
        line1.colors = [UIColor.magenta] //Sets the colour to magenta
        line1.setCircleColor(UIColor.magenta)
        line1.circleHoleColor = UIColor.magenta
        line1.circleRadius = 4.0
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        //Gradient fill
        let gradientColors = [UIColor.magenta.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return;
        }
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        //Axes set up
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.legend.enabled = true
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = true
        
        lineChart.data = data //finally - it adds the chart data to the chart and causes an update
        lineChart.chartDescription?.text = "January 1 - 7"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numbers.append(12)
        numbers.append(22)
        numbers.append(12)
        numbers.append(32)
        
        updateGraph()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
