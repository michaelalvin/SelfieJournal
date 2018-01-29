//
//  LogViewController.swift
//  imagepicker
//
//  Created by Michael Alvin on 1/14/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func action(_ sender: Any) {
        if(segmentControl.selectedSegmentIndex == 0) {
            // Logs User
            if usernameLabel.text != "" && passwordLabel.text != "" {
                
                Auth.auth().signIn(withEmail: usernameLabel.text!, password: passwordLabel.text!, completion: { (user, error) in
                    if user != nil {
                        self.performSegue(withIdentifier: "segue", sender: self)
                    } else {
                        
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("ERROR")
                        }
                    }
                    
                } )
            }
        } else {
            // Creates User
            Auth.auth().createUser(withEmail: usernameLabel.text!, password: passwordLabel.text!, completion: { (user, error) in
                
                if user != nil {
                    let databaseRef = Database.database().reference()
                    let userInfo = ["email": self.usernameLabel.text!, "uid": user?.uid, "emotions": [String](), "date": [String](), "username": "journaluser"] as [String : Any]
                    let userRef = databaseRef.child("users").child((user?.uid)!)
                    userRef.setValue(userInfo)
                    
                } else {
                    
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("ERROR")
                    }
                }
                
            } )
            
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl.tintColor = UIColor(rgb: 0xffffff)
        
                let gradient = CAGradientLayer()
        
                gradient.frame = view.bounds
                gradient.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        
                view.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
