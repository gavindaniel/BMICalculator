//
//  ViewController.swift
//  BMICalculator
//
//  Created by Gavin Daniel on 11/16/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var riskLabel: UILabel!
    
    struct bmiResults: Decodable {
        let bmi: Float
        let more: [String]
        let risk: String
    }
    
    var links = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))


        mainView.addGestureRecognizer(tap)
        
        
        
        self.heightTextField.delegate = self
        self.weightTextField.delegate = self
        
    }
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func calculateBMI(_ sender: UIButton) {
    
        self.view.endEditing(true)
        
        let heightData = heightTextField.text!
        let weightData = weightTextField.text!
        
        let urlAsString = "http://webstrar99.fulton.asu.edu/page3/Service1.svc/calculateBMI?height=\(heightData)&weight=\(weightData)"
        
        let url = URL(string: urlAsString)!
        
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            
            let decoder = JSONDecoder()
            let jsonResult = try! decoder.decode(bmiResults.self, from: data!)
            
            let bmi = jsonResult.bmi
            let more = jsonResult.more
            let risk = jsonResult.risk
            
            let bmiRes = String(format: "%.1f", bmi)
            let riskRes = risk
            
            self.links = more
            
            DispatchQueue.main.async {
                self.bmiLabel.text = bmiRes
                self.riskLabel.text = riskRes
                self.riskLabel.textColor = self.getColor(bmi: bmi)
            }
            
        })
        
        jsonQuery.resume()
        
    }
    
    func getColor(bmi: Float) -> UIColor {
        
        if (bmi < 18) {
            return UIColor.blue
        }
        else if (bmi >= 18 && bmi < 25) {
            return UIColor.green
        }
        else if (bmi >= 25 && bmi < 30) {
            return UIColor.purple
        }
        else { // if (bmi > 30) {
            return UIColor.red
        }
    }
    
    @IBAction func educate(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (self.links.count > 0) {
            let numLinks = (self.links.count) - 1
            
            guard let url = URL(string: self.links[Int.random(in: 0..<numLinks)]) else { return }
            UIApplication.shared.open(url)
        }
        
        else {
            self.riskLabel.text = "Calculate BMI first"
            self.riskLabel.textColor = UIColor.yellow
        }
        
    }
    
}

