//
//  ChartsViewController.swift
//  imagepicker
//
//  Created by Michael Alvin on 1/17/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChartsViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    var numbers = [12.0, 22.0, 12.0, 32.0] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    let months = ["Happy", "Sad", "Angry", "Surprised"]
    
    var pastSevenDays : [String] = []
    var pastSevenDaysAnger = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var pastSevenDaysSorrow = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var pastSevenDaysSurprised = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var pastSevenDaysJoy = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var emotionSegment: UISegmentedControl!
    
    @IBAction func emotionSegmentTapped(_ sender: Any) {
        if(emotionSegment.selectedSegmentIndex == 0) {
            lineChart.isHidden = true
            pieChart.isHidden = false
            getValuesFromFirebase()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // Put your code which should be executed with a delay here
                self.setChart(dataPoints: self.months, values: self.numbers)
            })
            
        } else {
            lineChart.isHidden = false
            pieChart.isHidden = true
            getValuesFromFirebase()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // Put your code which should be executed with a delay here
                self.updateLineGraph(color: self.emotionSegment.selectedSegmentIndex)
            })
        }
    }
    
    // Updates value in numbers, depending on how many
    func getPreviousWeek() {
        pastSevenDays = []
        
        let calendar = Calendar.current
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MM/dd/yyyy"
        
        for i in 0..<7 {
            var num = 6 - i // So that most recent date is last in our array
            num = num * -1
            let twoDaysAgo = calendar.date(byAdding: .day, value: num, to: Date())
            let stringDate = dayTimePeriodFormatter.string(from: twoDaysAgo!)
            pastSevenDays.append(stringDate)
        }
            
//            let userID = Auth.auth().currentUser?.uid
//                  ref.child("users").child(userID!).child("emotions").child(stringDate).child("surprise").setValue(arc4random_uniform(6) + 1)
        
    }
    
    func getValuesFromFirebase() {
        if let uid = Auth.auth().currentUser?.uid {
            numbers = [0.0, 0.0, 0.0, 0.0]
            let userID = Auth.auth().currentUser?.uid
            
            // Gets past 7 days into the string, then
            // have a forloop going through each day, then going through each emotion value,
            // adding them to numbers
            
            getPreviousWeek()
            
            for i in 0..<pastSevenDays.count {
                let date = pastSevenDays[i]
                
                var ref2 = ref.child("users").child(userID!).child("emotions").child(date).child("joy")
                ref2.observe(DataEventType.value, with: {
                    snapshot in
                    if let item = snapshot.value as? Int { // item is emotion int value
                        self.numbers[0] = self.numbers[0] + Double(item)
                        self.pastSevenDaysJoy[i] = Double(item)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                ref2 = ref.child("users").child(userID!).child("emotions").child(date).child("sorrow")
                ref2.observe(DataEventType.value, with: {
                    snapshot in
                    if let item = snapshot.value as? Int { // item is emotion int value
                        self.numbers[1] = self.numbers[1] + Double(item)
                        self.pastSevenDaysSorrow[i] = Double(item)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                ref2 = ref.child("users").child(userID!).child("emotions").child(date).child("anger")
                ref2.observe(DataEventType.value, with: {
                    snapshot in
                    if let item = snapshot.value as? Int { // item is emotion int value
                        self.numbers[2] = self.numbers[2] + Double(item)
                        self.pastSevenDaysAnger[i] = Double(item)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                ref2 = ref.child("users").child(userID!).child("emotions").child(date).child("surprise")
                ref2.observe(DataEventType.value, with: {
                    snapshot in
                    if let item = snapshot.value as? Int { // item is emotion int value
                        self.numbers[3] = self.numbers[3] + Double(item)
                        self.pastSevenDaysSurprised[i] = Double(item)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateLineGraph(color: Int){
        // Data
        var days : [String] = []
        
        for i in 0...6 {
            let day = pastSevenDays[i].replacingOccurrences(of: "/2018", with: "")
            days.append(day)
        }
        
        //let unitsSold = [20.0, 4.0, 3.0, 6.0, 12.0, 16.0, 4.0]
        if(emotionSegment.selectedSegmentIndex == 1) {
            lineChart.setLineChartData(xValues: days, yValues: pastSevenDaysJoy, label: "Number of Happy Moments", colorss: color)
        } else if(emotionSegment.selectedSegmentIndex == 2) {
            lineChart.setLineChartData(xValues: days, yValues: pastSevenDaysSorrow, label: "Number of Sad Moments", colorss: color)
        } else if(emotionSegment.selectedSegmentIndex == 3) {
            lineChart.setLineChartData(xValues: days, yValues: pastSevenDaysAnger, label: "Number of Anger Moments", colorss: color)
        } else {
            lineChart.setLineChartData(xValues: days, yValues: pastSevenDaysSurprised, label: "Number of Surprise Moments", colorss: color)
        }
    
        
        //lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        let description = pastSevenDays[0] + "-" + pastSevenDays[6]
        lineChart.chartDescription?.text = description
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
        
        let description = pastSevenDays[0] + "-" + pastSevenDays[6]
        pieChart.chartDescription?.text = description
    }
    
    override func viewDidLoad() {
        emotionSegment.tintColor = UIColor(rgb: 0xffbb4f)
        
        super.viewDidLoad()
        
        lineChart.isHidden = true
        pieChart.isHidden = false
        //setChart(dataPoints: months, values: numbers)
        
        getValuesFromFirebase()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.setChart(dataPoints: self.months, values: self.numbers)
        })
        
        // Gesture Recognizer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                //right view controller
                    self.performSegue(withIdentifier: "segue2", sender: self)
                //case UISwipeGestureRecognizerDirection.left:
                //left view controller
                //self.performSegue(withIdentifier: "segue1", sender: self)
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

