//
//  Calculations.swift
//  Calculator
//
//  Created by Firas Amin on 15/04/2016.
//  Copyright © 2016 Firas Amin. All rights reserved.
//


import Foundation

enum ErrorOcurred: ErrorType {
    case Empty
    case Short
    case Obvious(String)
}

enum OperationIndex {
    case FirstIndex
    case LastIndex

}


//implementation of protocol
 protocol calculationMethods {
    
    func operate(index:OperationIndex) throws -> String
    func performOperation(operation: (Double, Double) -> Double) throws -> String
    func calculatepercentage(operation: Double -> Double) throws -> String
    func clear() throws
    func enterValue(displayValue:Double) throws
    func convertToDoubleValue(value: String) throws -> Double
    
}

class Calculations : calculationMethods {

    var operandStack = [Double]()
    var operationStack = [String]()
    

    
    func operate(index: OperationIndex) throws -> String {
        
        var result: String = ""
        var operation: String = ""
        
        switch index {
        case  .FirstIndex :
            // make sure that operation stack contains only last two operation signs entered e.g [2.0 , 56.0]
            if operationStack.count > 2 {
                operationStack.removeFirst()
            }
            // take the operation sign entered
            operation =  operationStack.removeFirst()
            
            break
            
        case  .LastIndex :
            operation =   operationStack.removeFirst()
            break
        }
        
        if operandStack.count < 2  {
            
            print("need to enter one more digit, digits now : ",  operandStack.count)
            
        }
        
        
        
        print("OperationStack = ", operationStack )

        
        // The last operation entered used here
        
        switch operation {
        case "×":
            do { result = try performOperation { $0 * $1 }}
        catch {ErrorOcurred.Obvious("Muliplying func catched an error")}
        case "÷":
            do { result = try performOperation { $1 / $0 }}
        catch {ErrorOcurred.Obvious("Division func catched an error")}
        case "+":
            do { result = try performOperation { $0 + $1 }}
        catch {ErrorOcurred.Obvious("adding func catched an error")}
        case "-":
            do {result = try performOperation { $1 - $0 }}
        catch {"Substacting func catched an error"}
        case "%":
            do {result = try calculatepercentage{$0}} catch {}
            
        default: break
        }
        
        return result
    }
    
     func performOperation(operation: (Double, Double) -> Double) throws ->  String {
        var result : Double = 0.0
        
        //  if operandStack.count >= 2 {
        result = operation(operandStack.removeLast(), operandStack.removeLast())
        
        enterValue(result)
        print("result is : ", result)
        
        //   }
        return try convertDotToComma(result)
    }
    
        func calculatepercentage(operation: Double -> Double) throws -> String {
        var result : Double = 0.0
        result = operation(operandStack.removeLast() / 100)
        // enterValue(result)
        return try convertDotToComma(result)
    }
    
    
    func clear() throws {
        operandStack.removeAll()
        operationStack.removeAll()
    }
    
    //enter operation signs into array
    func enterOperation(operation : String) throws {
        
        //empty operation stack
        //operationStack.removeAll()
        
        //append new value
        operationStack.append(operation)

        print("operation entered = ", "\(operationStack)" )
    }
    
     func enterValue(displayValue : Double) {
        
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
        
    }
    
    func enterValue(displayValue:String) throws {
        
        
        let value = try convertToDoubleValue(displayValue)
        
        enterValue(value)
    }
    
      func convertToDoubleValue(value: String)  throws-> Double {
        
        let display = value.stringByReplacingOccurrencesOfString(",", withString: ".")
        
        
        return (display as NSString).doubleValue
    }
    
    
      func convertDotToComma(numberWithDot: Double) throws -> String {
        // setup nsnumber formatter to remove zeros after comma
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
        //formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 20
        formatter.roundingMode = .RoundDown
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .NoStyle
        
        let numberStr = String(format: "%.20f", numberWithDot)
        let number = formatter.numberFromString(numberStr)
        
        // put comma insted of dot
        let res:String
        
        res = formatter.stringFromNumber(number!)!
        let result = res.stringByReplacingOccurrencesOfString(".", withString: ",")
        return result
    }
    
    func treatDisplayNumber(displayNumber:String) throws -> String {
        var result: String = ""
        let doubleValue = try convertToDoubleValue(displayNumber)
        result = try convertDotToComma(doubleValue)
        return result
    }
    
}


