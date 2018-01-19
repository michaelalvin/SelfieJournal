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

    
    var numbers = [12.0, 22.0, 12.0, 32.0] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    let months = ["Happy", "Sad", "Angry", "Surprised"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0]
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var emotionSegment: UISegmentedControl!
   
    @IBAction func emotionSegmentTapped(_ sender: Any) {
        if(emotionSegment.selectedSegmentIndex == 0) {
            lineChart.isHidden = true
            pieChart.isHidden = false
            setChart(dataPoints: months, values: unitsSold)
        } else {
            lineChart.isHidden = false
            pieChart.isHidden = true
            updateLineGraph()
        }
    }
    
    
    func updateLineGraph(){
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
        
        var gradientColors = [UIColor.magenta.cgColor, UIColor.clear.cgColor] as CFArray
        var color = UIColor.magenta
        
        if(emotionSegment.selectedSegmentIndex == 1) {
            line1.colors = [UIColor.magenta] //Sets the colour to magenta
            line1.setCircleColor(UIColor.magenta)
            line1.circleHoleColor = UIColor.magenta
        } else if (emotionSegment.selectedSegmentIndex == 2){
            color = UIColor(rgb: 0x559efc)
            line1.colors = [color] //Sets the colour to magenta
            line1.setCircleColor(color)
            line1.circleHoleColor = color
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        } else if (emotionSegment.selectedSegmentIndex == 3){
            color = UIColor(rgb: 0xff2d2d)
            line1.colors = [color] //Sets the colour to magenta
            line1.setCircleColor(color)
            line1.circleHoleColor = color
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        } else {
            color = UIColor(rgb: 0x64dd49)
            line1.colors = [color] //Sets the colour to magenta
            line1.setCircleColor(color)
            line1.circleHoleColor = color
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        }
        
        
        line1.circleRadius = 4.0
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        //Gradient fill
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry1)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        var colors: [UIColor] = []
        
        //Happy
        var color = UIColor.magenta
        colors.append(color)
        
        //Sad
        color = UIColor(rgb: 0x559efc)
        colors.append(color)
        
        //Angry
        color = UIColor(rgb: 0xff2d2d)
        colors.append(color)
        
        //Surprised
        color = UIColor(rgb: 0x64dd49)
        colors.append(color)
        
        //Pie Chart Modifications
        pieChart.usePercentValuesEnabled = true
        pieChart.drawSlicesUnderHoleEnabled = false
        pieChart.holeRadiusPercent = 0.60
        pieChart.transparentCircleRadiusPercent = 0.43
        pieChart.drawHoleEnabled = true
        pieChart.rotationAngle = 0.0
        pieChart.rotationEnabled = true
        pieChart.highlightPerTapEnabled = false
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        //Pie Chart Setup
        pieChartDataSet.colors = colors
        pieChart.legend.enabled = true
        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        pieChart.data = pieChartData
        pieChart.chartDescription?.text = "January 1 - 7"
    }
    
    override func viewDidLoad() {
        emotionSegment.tintColor = UIColor(rgb: 0xffbb4f)
        
        super.viewDidLoad()
        
        lineChart.isHidden = true
        pieChart.isHidden = false
        setChart(dataPoints: months, values: unitsSold)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
