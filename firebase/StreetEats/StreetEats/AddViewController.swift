//
//  AddViewController.swift
//  StreetEats
//
//  Created by Adriel Tolentino on 9/26/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    let locationManager = CLLocationManager()
    var refFood: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latitudeField.isUserInteractionEnabled = false
        longitudeField.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
        refFood = Database.database().reference().child("Food");
    }
    
    @IBAction func getCurrentCoordinate(_ sender: UIButton) {
        var currentLocation: CLLocation!
        currentLocation = locationManager.location
        let latitude = "\(currentLocation.coordinate.latitude)"
        let longitude = "\(currentLocation.coordinate.longitude)"
        
        latitudeField.text = latitude
        longitudeField.text = longitude
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let cartName = nameField.text
        let typeFood = typeField.text

        // Checks for empty fields
        if((cartName?.isEmpty)! || (typeFood?.isEmpty)!)
        {
            // Display an alert message
            displayAlertMessage(myMessage: "Fields can't be empty")
            return;
        }
        
        // Get Current Coordinate
        var currentLocation: CLLocation!
        currentLocation = locationManager.location
        
        let longitude = "\(currentLocation.coordinate.longitude)"
        let latitude = "\(currentLocation.coordinate.latitude)"
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        // Add the following data to Firebase Database
        let key = refFood.childByAutoId().key
        
        let food = [
            "id": key as Any,
            "cartName": cartName as Any,
            "typeFood": typeFood as Any,
            "latitude": latitude,
            "longitude": longitude,
            "month": components.month as Any,
            "day": components.day as Any,
            "hour": components.hour as Any,
            "minutes": components.minute as Any,
            ] as [String : Any]
        refFood.child(key!).setValue(food)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
    // Function that displays an alert message to the user
    func displayAlertMessage(myMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}