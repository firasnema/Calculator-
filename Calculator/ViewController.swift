//
//  ViewController.swift
//  Calculator
//
//  Created by Firas Amin on 13/04/2016.
//  Copyright © 2016 Firas Amin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isTypingNumber = false
    var operantion = ""
    var userInTheMiddleOFTyping = true
    var isFirstNumberTapped  = false
    var isSecondNumberTapped = false
    
    var numEntered : String = "0"
    
    var userIsInTheMiddleOfDoingCalculation = false
    var isOperationTapped = false
    
    var lastOperationTapped: String = ""
    var signTapped = false
    var isNotFinishedCalculation = false
    
    var equalButtonTapped = false
    
    var buttonTapped : Int = 0
    
    
    
    
    var calculation = Calculations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBOutlet weak var calculatorDisplay: UILabel!
    
    @IBOutlet weak var clearTapped: UIButton!
    
    
    @IBAction func clearTapped(sender: UIButton) {
        
        performButtonAnimation(sender)
        
        isTypingNumber = false
        //isOperationTapped = false
        isFirstNumberTapped = false
        isNotFinishedCalculation = false
        
        // hasComma = false
        
        if sender.currentTitle == "C" {
            calculatorDisplay.text = "0"
        }else {
            
            calculatorDisplay.text = "0"
            
            do{
                try calculation.clear()}
            catch {ErrorOcurred.Obvious(" Error occured while trying to empty array")}
            
        }
        sender.setTitle("AC", forState: UIControlState.Normal)
        
    }
    
    @IBAction func signTapped(sender: UIButton) {
        //performButtonAnimation(sender)
        guard self.calculatorDisplay.text!.containsString("-") else {
            self.calculatorDisplay.text! = "-" + self.calculatorDisplay.text!
            print("has no comma, now it has :b")
            return
        }
        self.calculatorDisplay.text = self.calculatorDisplay.text?.stringByReplacingOccurrencesOfString("-", withString: "")
        
    }
    @IBAction func numberTapped(sender: UIButton) {
        
        
        performButtonAnimation(sender)
        isFirstNumberTapped = true
        isSecondNumberTapped = true
        numEntered = sender.currentTitle!
        userIsInTheMiddleOfDoingCalculation = true
        
        
        //  self.calculatorDisplay.text! = sender.currentTitle!
        
        if clearTapped.currentTitle == "AC" {
            clearTapped.setTitle("C", forState: UIControlState.Normal)
        }
        
        // do not take first zeros at start of typing
        if numEntered == "0" && self.calculatorDisplay.text == "0"  {
            numEntered = ""
            return
        }
        
        
        guard isTypingNumber == true else {
            
            self.calculatorDisplay.text = numEntered
            
            if self.calculatorDisplay.text!.containsString(",")  && numEntered == "," {
                self.calculatorDisplay.text = "0" + numEntered
                do {
                    try calculation.clear()}
                catch {ErrorOcurred.Obvious("Error ocurred while calling method clear")}
            }else {
                self.calculatorDisplay.text =  numEntered
            }
            
            isTypingNumber = true
            return
        }
        
        
        self.calculatorDisplay.text! += ((numEntered == "," && self.calculatorDisplay.text!.rangeOfString(",") != nil) ?  "" : numEntered)
        
    }
    
    
    @IBAction func percentsignTapped(sender: UIButton) {
        
        var result : String = ""
        isTypingNumber = false
        performButtonAnimation(sender)
        
        
        // jumb over and do nothing if user tapped only percent buttom without number before
        guard isFirstNumberTapped else {
            print("No number is tapped" )
            return
        }
        //if the entered value and the operation sign where tapped, then enter both into theier belonging array
        
        //enter the value of the button tapped
        do {
            try calculation.enterValue(self.calculatorDisplay.text!) }
        catch {ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")}
        
        
        
        //enter the operation sign of the button entered
        do {
            try calculation.enterOperation(sender.currentTitle!) }
        catch {ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")}
        
        
        // make sure that calculation is acheived
        guard isNotFinishedCalculation else  {
            print("calculatin is not done")
            
            do {
                result = try calculation.operate(OperationIndex.FirstIndex)}
            catch {ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")}
            
            calculatorDisplay.text = "\(result)"
            print ("Percentage calculation based on ONE value")
            
            return
        }
        
        guard isOperationTapped && !isSecondNumberTapped else {
            print ("Percentage calculation based on ONE value")
            return
        }
        
        // if we come from some things like pct(2 x 4) , then use the arry of the entered value and
        do {
            try calculation.operate(OperationIndex.FirstIndex) }    //first index in the array
        catch {
            ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")
        }
        
        do {
            try result = calculation.operate(OperationIndex.LastIndex) }  //last index in the array
        catch {
            ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")
        }
        
        print ("Percentage calculation based on TWO value")
        
        calculatorDisplay.text = "\(result)"
        isNotFinishedCalculation = false
        
    }
    
    @IBAction func OperationTapped(sender: UIButton) {
        
        performButtonAnimation(sender)
        isTypingNumber = false
        isNotFinishedCalculation = true
        isSecondNumberTapped = false
        
        
        
        //-----------------------------------------
        
        // User is in the first part of calculation
        
        //-----------------------------------------
        
        
        // user must type a number, otherwis jumb, ignor that operation pressed again and again
        guard isFirstNumberTapped else {
            
            print("you have to tap a number")
            return
        }
        
        
        //----------------------------------------
        
        // user in the MIDDLE of doing calculation
        
        // ---------------------------------------
        
        // use lastOperationTapped when calculation require substracting value from itself, in case of pressing equal sig without chosing another number to substract.
        
        lastOperationTapped = sender.currentTitle!
        
        //make sure that user is in the middle og doing calculaiton
        
        guard userIsInTheMiddleOfDoingCalculation else {
            userIsInTheMiddleOfDoingCalculation = false
            
            do {
                try calculation.enterOperation(sender.currentTitle!)}
            catch {ErrorOcurred.Obvious("Error occured while entering calling enterOperation method, when operation tapped")
            }
            
            print("User pressed another button")
            
            return
        }
        
        //if user in the meddle of doing calculaiton, then go ahead and save operation sig and value
        do {
            try calculation.enterOperation(sender.currentTitle!)}
        catch {ErrorOcurred.Obvious("Error occured while entering calling enterOperation method, when operation tapped")
        }
        
        do{
            try calculation.enterValue(self.calculatorDisplay.text!)}
        catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
        
        
        // put equal button to be true, making operation button to work like equal botton
        equalButtonTapped = true
        
        //-------------------------------------
        
        // USER In the Last part of calculation
        
        //-------------------------------------
        
        // make sure that calculation is not occured when typing operation at the first time
        //do calculation only if operation sign and value tapped
        guard isOperationTapped && isFirstNumberTapped else {
            
            //next time do not enter operation sign and value to the array
            isOperationTapped = true
            //numTapped = true
            
            //user is now out of the middle of doing calculaiton
            userIsInTheMiddleOfDoingCalculation = true
            
            print("operation sign and value is entered")
            return
        }
        
        //if equal not tapped before, then jumb to the next level, calculating the entered values
        guard equalButtonTapped else {
            print("Coming from equal sign")
            return
        }
        
        //call method with an argument that is the first index in the operationStack
        do {
            self.calculatorDisplay.text =  try calculation.operate(OperationIndex.FirstIndex)}
        catch {
            ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
        }
        
        
    }
    
    
    @IBAction func equlsTapped(sender: UIButton) {
        
        performButtonAnimation(sender)
        userIsInTheMiddleOfDoingCalculation = false
        isTypingNumber = false
        isFirstNumberTapped = false
        
        
        //when pressing equl sign, otherwise reset the desplay, removing comma
        guard isOperationTapped else {
            
            //remove "," if it not important
            if numEntered == "," {
                do {
                    self.calculatorDisplay.text = try calculation.treatDisplayNumber(self.calculatorDisplay.text!)}
                catch {ErrorOcurred.Obvious("Error occured while calling method treatDisplayNumber")}
                
                //                self.calculatorDisplay.text = self.calculatorDisplay.text?.stringByReplacingOccurrencesOfString(",",                  withString: "")
            }
            return
        }
        
        // In case of user presses "," ,instead use zero as an argument
        
        
        if numEntered == "," {
            numEntered = "0"
        }
        
        //make sure to save value and operation sign, next time user pressing an operation button
        equalButtonTapped = true
        isFirstNumberTapped = true
        
        
        // enter value and operation into their arrays, and perform calculaiton using them
        do {
            try calculation.enterValue(numEntered)}
        catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
        
        do {
            try calculation.enterOperation(lastOperationTapped)}
        catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
        
        do {
            self.calculatorDisplay.text = try calculation.operate(OperationIndex.FirstIndex)} catch {
                ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
        }
    }
}


private func performButtonAnimation(sender : UIButton) -> UIButton {
    sender.transform = CGAffineTransformMakeScale(0.95, 0.95)
    UIView.animateWithDuration(2.0,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 6.0,
                               options: UIViewAnimationOptions.AllowUserInteraction,
                               animations: {
                                sender.transform = CGAffineTransformIdentity
        }, completion: nil)
    
    return sender
}



