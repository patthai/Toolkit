//
//  Sentence.swift
//  api and index
//
//  Created by Valdemar Danry on 10/09/2019.
//  Copyright © 2019 Valdemar Danry. All rights reserved.
//

import Foundation

class Sentence{
    
    var num : Int = 0
    var type : String = ""
    var string: String = ""
    
    init(num: Int){
        self.num = num
    }
    
    init(type:String){
        self.type = type
    }
    
    init(string:String){
        self.string = string
    }
}

/*class Argument{
    var Sentence : AnyObject
    
    init(Sentence: AnyObject){
        self.Sentence = Sentence
    }
}*/

protocol Argument{
    
}
