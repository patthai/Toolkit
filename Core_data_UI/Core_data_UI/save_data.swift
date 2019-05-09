//
//  ViewController.swift
//  Core_data_UI
//
//  Created by pat pataranutaporn on 5/8/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var insert_button: UIButton!
    
    let nscontext = ((UIApplication.shared.delegate) as!
        AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func INsert(_ sender: Any) {
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Login",into: nscontext)
        entity.setValue(emailid.text, forKey:"email") // email is a Your Entity Key
        entity.setValue(password.text, forKey: "password")
        do
        {
            try nscontext.save()
            emailid.text = ""
            password.text = ""
            
        }
        catch
        {
            
        }
        print("Record Inserted")
        self.navigationController?.popViewController(animated: true)
    }
    

}

