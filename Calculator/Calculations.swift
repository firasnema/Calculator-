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
    func calculatepercentage(operation: (Double, Double) -> Double) throws -> String
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
        
        if operationStack.count > 2 {
            operationStack.removeFirst()
        }
        
        print("operand Stack before updating = ", operandStack )
        
        switch index {
        case  .FirstIndex :
            // make sure that operation stack contains only last two operation signs entered e.g [2.0 , 56.0]
            
            // take the operation sign entered
            operation =  operationStack[0]
            
            break
            
        case  .LastIndex :
            operation =   operationStack[1]
            break
        }
        
        
        
        
        // The last operation entered used here
        
        switch operation {
        case "×":
            do { result = try performOperation { $0 * $1 }}
            catch {ErrorOcurred.Obvious("Muliplying func catched an error")}
        case "÷":
            do { result = try performOperation { $0 / $1 }}
            catch {ErrorOcurred.Obvious("Division func catched an error")}
        case "+":
            do { result = try performOperation { $0 + $1 }}
            catch {ErrorOcurred.Obvious("adding func catched an error")}
        case "-":
            do {result = try performOperation { $0 - $1 }}
            catch {"Substacting func catched an error"}
        case "%":
            switch operationStack[0] {
            case "+" , "-":
                do {result = try calculatepercentage{ $0 * $1 / 100}} catch {}
                break
                
            case "÷" , "×" :
                do {result = try calculatepercentageOfANumber{ $0 * $1 / 100}} catch {}
                break
            default:
                do {result = try calculatepercentageOfANumber{ $0 * $1 / 100}} catch {}
                break
            }
            
        default: break
        }
        
        return result
    }
    
    func performOperation(operation: (Double, Double) -> Double) throws ->  String {
        var result : Double = 0.0
        
        let value =  operandStack[1]
        guard operandStack.count > 2 else {
            
            result = operation(operandStack.removeFirst(), operandStack.removeLast())
            
            enterValue(result)
            enterValue(value)
            
            return try convertDotToComma(result)
        }
        
        result = operation(operandStack.removeLast(), operandStack.removeLast())
        
        enterValue(result)
        
        
        return try convertDotToComma(result)
    }
    
    func calculatepercentage(operation: (Double, Double )-> Double) throws -> String {
        var result : Double = 0.0
        
        // calculate percentage of a number e.g  5 + 9%, otherwise calculate percentage of the number
        
        result = operation(operandStack[0], operandStack[1] )
        updateValue(result)
        print("new value is updated :", operandStack)
        return try convertDotToComma(result)
    }
    
    func calculatepercentageOfANumber(operation: (Double, Double )-> Double) throws -> String  {
        var result : Double = 0.0
        
        // calculate percentage of a number e.g  5 + 9%, otherwise calculate percentage of the number
        
        result = operation(1.0 , operandStack[1])
        updateValue(result)
        print("new value is updated :", operandStack)
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
        print("Operation entered: ", operationStack)
    }
    
    func updateValue(value:Double) -> Double {
        
        guard operandStack.count > 1 else {
            operandStack[0] = value
            return operandStack[0]
        }
        operandStack[1] = value
        return operandStack[1]
        
    }
    
    func enterValue(displayValue : Double) {
        
        operandStack.append(displayValue)
        updateValue(displayValue)
        print("operand Stack entered value  = \(operandStack)")
        
    }
    
    func enterValue(displayValue:String) throws {
        
        
        let value = try convertToDoubleValue(displayValue)
        
        enterValue(value)
    }
    
    func userChangedOperationValue(value: String) throws -> Bool {
        
        let displayValue  = value.stringByReplacingOccurrencesOfString(",", withString: ".")
        
        operandStack.append( Double(displayValue)!)
        guard Double(displayValue) != operandStack[1] else {
            
            return false
        }
        
        operandStack.removeAtIndex(1)
        // operandStack[1] = Double(displayValue)!
        
        print("user has chanaged operation value")
        return true
    }
    
    
    func convertToDoubleValue(value: String)  throws-> Double {
        
        let display = value.stringByReplacingOccurrencesOfString(",", withString: ".")
        
        
        return (display as NSString).doubleValue
    }
    
    func updateOperationWith(newOperation: String) throws {
        
        operationStack.append(newOperation)
        
        guard operationStack.count > 1 else {
            
            print("Operation stack updated: ", operationStack)
            return
        }
        
        // removing the element before the last entered element
        operationStack.removeAtIndex(operationStack.count - 2 )
        
        print("Operation stack updated: ", operationStack)
        
    }
    
    
    func convertDotToComma(numberWithDot: Double) throws -> String {
        // setup nsnumber formatter to remove zeros after comma
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
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


