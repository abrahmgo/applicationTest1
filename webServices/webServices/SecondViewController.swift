//
//  SecondViewController.swift
//  webServices
//
//  Created by Andres Abraham Bonilla Gòmez on 25/07/18.
//  Copyright © 2018 beHere. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var showURL: UILabel!
    @IBOutlet weak var labelNameCountry: UILabel!
    var urlCountry: String = ""
    var nameCountry: String = ""
    
    
    
    let classWeb = funcWeb()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        labelNameCountry.text = nameCountry
        inputText.delegate = self
        classWeb.dataForCountry(url: urlCountry) { (flag) in
            print(self.classWeb.urlCountryArray)
            print(self.classWeb.typeInputCountryArray)
            self.showURL.text = self.classWeb.urlCountryArray
        }
        
        if self.classWeb.typeInputCountryArray == "Number"
        {
            self.inputText.keyboardType = UIKeyboardType.numberPad
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.classWeb.typeInputCountryArray == "number"
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        else if self.classWeb.typeInputCountryArray == "text"
        {
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil
            {
                return false
            }
            return true
        }
        else
        {
            
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputText.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?)
    {
        self.view.endEditing(true)
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
