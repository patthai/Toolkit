//
//  ViewController.swift
//  iOS-Flask Sever
//
//  Created by pat pataranutaporn on 12/16/18.
//  Copyright © 2018 pat pataranutaporn. All rights reserved.
//

import UIKit

//////////////////////////////////Server Configuration
typealias StringCompletion      = (_ success: Bool, _ string: String) -> Void
var apiBaseURL: String = "https://62ba5783.ngrok.io"


class ViewController: UIViewController {
    
    var return_text = ""

    @IBOutlet weak var send_button: UIButton!
    @IBOutlet weak var return_text_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func update_text()
    {
        return_text_field.text = return_text
        
    }
    

     //////////////////////////////////Send Button
    
    @IBAction func send_button_activate(_ sender: Any) {
        print("Send request to server")
        let json : [String : String] = ["dinosaur" : "t-rex", "people" : "einstein"]
        print (json)
        var response = apiPost(endpoint: "/args", json: json, onSuccess: {(success, string) in
            if success {
                print("Success: \(string)")
                DispatchQueue.main.sync {
                    self.return_text = string
                    self.update_text()
                }
            }
            else {
                print("Failure: Unable To Get String")
            }
        })
    }
    
    
    
    
}
 ////////////////////////////////Send Function

func apiPost(endpoint: String, json: [String : String], onSuccess: @escaping StringCompletion){
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    let url = URL(string: apiBaseURL + endpoint)
    //print("POST " + apiBaseURL + endpoint)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            //print("data")
            //print(data)
            //print("response")
            //print(response)
            let result = String(data: data, encoding: .utf8)
            if(result as? String != nil){
                onSuccess(true, result!)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    task.resume()
    
}


