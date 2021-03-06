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
    var isFirstNumberTapped  = false
    
    
    var numEntered : String = "0"
    
    var userIsInTheMiddleOfDoingCalculation = false
    var isCalculationOperationSignTapped = false
    
    var isNotFinishedCalculation = false
    
    var equalButtonTapped = false
    
    var buttonTapped : Int = 0
    
    var isOperationTapped = false
    
    var isPecentTapped = false
    
    var isNumFormDisplay = false
    
    
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
            isCalculationOperationSignTapped = false
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
        
        isNumFormDisplay = false
        numEntered = sender.currentTitle!
        userIsInTheMiddleOfDoingCalculation = true
        isOperationTapped = false
        isFirstNumberTapped = true
        

        
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
        isPecentTapped = true
        
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
        
        
        // make sure that calculation is acheived when the user pressed a number and thereafter percent sign
        guard isNotFinishedCalculation else  {
            print("calculatin is not done")
            
            do {
                result = try calculation.operate(OperationIndex.FirstIndex)}
            catch {ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")}
            
            calculatorDisplay.text = "\(result)"
            print ("Percentage calculation based on ONE value")
            
            userIsInTheMiddleOfDoingCalculation = false
            isCalculationOperationSignTapped = true
            return
        }
        
        
        // calculate percentage of a number when user pressed some things like 2 + 4% (of 2), then use the arry of the entered value and
        guard isCalculationOperationSignTapped else {
            
            return
        }
        
        
        do {
            try result = calculation.operate(OperationIndex.LastIndex) }  //last index in the array
        catch {
            ErrorOcurred.Obvious("Error occured while calling enterValue method, when precent sign tapped")
        }
        print ("Percentage calculation based on TWO value")
        
        calculatorDisplay.text = "\(result)"
        isNotFinishedCalculation = false
        isOperationTapped = true
        
    }
    
    @IBAction func OperationTapped(sender: UIButton) {
        
        performButtonAnimation(sender)
        isTypingNumber = false
        isNotFinishedCalculation = true
        
        
        // user must type a number, otherwis jumb, ignor that operation pressed again and again
        guard  isFirstNumberTapped else {
            
            print("you have to tap a number")
            return
        }
        
        
        //----------------------------------------
        
        // user in the MIDDLE of doing calculation
        
        // ---------------------------------------
        
        // use lastOperationTapped when calculation require substracting value from itself, in case of pressing equal sig without chosing another number to substract.
        
        
        //when user in the meddile of doing calculation
        
        guard userIsInTheMiddleOfDoingCalculation else {
            userIsInTheMiddleOfDoingCalculation = false
            
            do {
                try calculation.updateOperationWith(sender.currentTitle!)}
            catch {ErrorOcurred.Obvious("Error occured while entering calling enterOperation method, when operation tapped")
            }
            
            print("User pressed another button")
            
            return
        }
        
        // make sure that the operation stack is updated if the user has changed operation sign
        guard isFirstNumberTapped && !isOperationTapped else {
            
            
            // update operation stack
            do { try calculation.updateOperationWith(sender.currentTitle!)} catch {
                
                ErrorOcurred.Obvious("Error occured while updating operation with new operation sign")
            }
            
            
            // make sure that percentage is calculated here
            
            switch sender.currentTitle! {
            case "×" , "÷" :
                
                
                break
                
            case "-" , "+" :
                if isPecentTapped {
                    isPecentTapped = false
                    //call method with an argument that is the first index in the operationStack
                    do {
                        self.calculatorDisplay.text =  try calculation.operate(OperationIndex.FirstIndex)}
                    catch {
                        ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
                    }
                }
                break
            default:
                break
            }
            
            
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
        isFirstNumberTapped  = true
        isOperationTapped = true
        
        //-------------------------------------
        
        // USER In the Last part of calculation
        
        //-------------------------------------
        
        
        // make sure that calculation is not occured when typing operation at the first time
        //do calculation only if operation sign and value tapped
        
        guard isCalculationOperationSignTapped && isFirstNumberTapped else {
            
            //next time do not enter operation sign and value to the array
            isCalculationOperationSignTapped = true
            
            
            
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
        //isFirstNumberTapped = false
        
        
        //when pressing equl sign, otherwise reset the desplay, removing comma
        guard isCalculationOperationSignTapped else {
            
            //remove "," if it not important
            if numEntered == "," {
                do {
                    self.calculatorDisplay.text = try calculation.treatDisplayNumber(self.calculatorDisplay.text!)}
                catch {ErrorOcurred.Obvious("Error occured while calling method treatDisplayNumber")}
                
            }
            return
        }
        
        // In case of user presses "," ,instead use zero as an argument
        
        if numEntered == "," {
            self.calculatorDisplay.text! = "0"
        }
        
        //make sure to save value and operation sign, next time user pressing an operation button
        equalButtonTapped = true
        
        guard isFirstNumberTapped == true else {
            
            return
        }
        
        guard !isPecentTapped else {
            
            
            guard isNumFormDisplay else {
                
                isNumFormDisplay = true
                
                numEntered = self.calculatorDisplay.text!
                
                do {
                    isOperationTapped = true
                    self.calculatorDisplay.text = try calculation.operate(OperationIndex.FirstIndex)} catch {
                        ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
                }
                do {
                    try calculation.enterValue(numEntered)}
                catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
                
                // calculation.operationStack.removeLast()
                
                return
            }
            
            
            do {
                isOperationTapped = true
                self.calculatorDisplay.text = try calculation.operate(OperationIndex.FirstIndex)} catch {
                    ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
            }
            
            do {
                try calculation.enterValue(numEntered)}
            catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
            
            return
        }
        
        // enter value and operation into their arrays, and perform calculaiton using them
        
        if !isNumFormDisplay  {
            isNumFormDisplay = true
            do {
                try calculation.userChangedOperationValue(self.calculatorDisplay.text!)}
            catch {ErrorOcurred.Obvious("Error occured while entering calling enterValue method, when operation tapped")}
            
            
        }
        
        
        do {
            self.calculatorDisplay.text = try calculation.operate(OperationIndex.FirstIndex)} catch {
                ErrorOcurred.Obvious("Error occured while entering calling operate method, when operation tapped")
        }
        
        
    }
}


private func performButtonAnimation(sender : UIButton) -> UIButton {
    sender.transform = CGAffineTransformMakeScale(0.93, 0.93)
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



