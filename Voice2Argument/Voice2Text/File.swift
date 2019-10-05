//
//  File.swift
//  api and index
//
//  Created by Valdemar Danry on 10/09/2019.
//  Copyright © 2019 Valdemar Danry. All rights reserved.
//

import Foundation
var completionHandler: ((String)-> ())? //@escaping effort

func process_JSON(value: Array<AnyObject>,prettyPrinted:Bool = false) -> String
{
    var claim_num : Int = 0
    var premise_num : Int = 0
    var noClaim = true //never read because I don't know what to do when multiple claims
    var noPremise = true
    var returnString = ""
    //print (type(of: value))
    
    
    var sentence = (0...value.count).map(Sentence.init)
    
    //cycle through sentences to add words
    for i in 0..<value.count {
        
        //cycle through words
        for j in 0..<value[i].count {
            
            //extracting information
            if let value = value[i][j] as? [String: Any], let label = value["label"] as? String {
                //let prob = value["prob"] as Any
                let token = value["token"] as! String
                
                
                //If necc add spacing
                if token != "." && token != "," && j != 0{
                    sentence[i].string.append(" ")
                }
                
                //Add word
                sentence[i].string.append(token)
                
                //check if premise or claim
                if label == "P-B" {
                    sentence[i].type = "Premise"
                    //premise_num += 1
                    
                }
                else if label == "C-B"{
                    sentence[i].type = "Claim"
                    //claim_num += 1
                }
            }
        }
        print( "(", sentence[i].type, ")" , sentence[i].string)
    }
    print("")
    
    //MAKE A SENTENCE WITH OVERVIEW TO RETURN//
    //--note: it is assumed that only one claim is present--//
    for i in 0..<value.count {
        
        //Insert claim section
        if sentence[i].type == "Claim" /*noClaim == true*/ {
            returnString += "The claim was \"\(sentence[i].string)\" "
            noClaim = false
        }
            
            //Insert premise section
        else if sentence[i].type == "Premise"{
            var premiseNum = 0
            
            if noPremise == true {
                returnString += "because of the reason \"\(sentence[i].string)\""
                premiseNum += 1
                noPremise = false
                Global.premise_check="No"
                print (Global.premise_check)
            }
            else {
                returnString += "and because of the \(premiseNum). reason '\(sentence[i].string)"
                premiseNum += 1
            }
        }
    }
    //Add a period.
    returnString += "."
    
    //Print OVERVIEW text
    print(returnString)
    print("")
    print("")
    return ""
    
    return ""
    
}
func postAction(argument: String, completion: @escaping (String)-> () ) { //@escaping effort
    
    //PROBLEM how do I use @escape for boolean and string
    //function inside function --not important
    //why is it called twice?
    

    
    
    let Url = String(format: "http://ltdemos.informatik.uni-hamburg.de/arg-api//classifyIBMfasttext")
    guard let serviceUrl = URL(string: Url) else { return completion("error") }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("Content-Type: text/plain", forHTTPHeaderField: "Accept: application/json")
    
    //Let the data sent for processing be voice data
    //let bodyData = argument //call for voice
    let bodyData = "We should disband the United Nations. The United Nations did not condemn the killings in the strongest possible terms, and the French Council of the Muslim Faith also did not condemn the attacks." //call for template
    request.httpBody = bodyData.data(using: .utf8)
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        
        //check for connection
        /*if let response = response {
            print(response)
        }*/
        
        //receiving the data
        if let data = data {
            do {
                var json : [AnyObject] = []
                json = try JSONSerialization.jsonObject(with: data, options: []) as! [AnyObject]
                print (type(of: json))
                process_JSON(value: json as Array)
                
                //sorting the data// ------could make a function but i can't make it work
            
            } catch {
                print(error)
            }
        }
        
        completionHandler.self = completion //@escape effort
        
    }.resume() // der er noget med den her ift. returnString
    
    //return completion(returnString, noPremise) //return effort
}
