//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Firas Amin on 13/04/2016.
//  Copyright © 2016 Firas Amin. All rights reserved.
//

import XCTest

@testable import Calculator

class CalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // method used to convert value of string to double value and makes other tasks
    
    func testConvertToDoubleValue () {
    let obj = Calculations()
        let value: String = "2.0"
        XCTAssertEqual(try! obj.convertToDoubleValue(value), 2.0)
        
    
    }
    
// test perfomance of method "operate", it is working fine
    
    
    // test mehod used to calculate multiplication substraction, adding, divission, and percentage
    func testperformOperation()  {

        let obj = Calculations()
        
        obj.operationStack.removeAll()
        obj.operandStack.appendContentsOf([2.0, 3.0])
        obj.operationStack.appendContentsOf(["×"])
        XCTAssertEqual( try! obj.operate(OperationIndex.FirstIndex) , "6")
      
            }
    
    
    // method takes value with zeros efter the comma and return string
    func testtreatDisplayNumber() {
    
    let obj = Calculations()
    let value = "2.5000"
      XCTAssertEqual(try! obj.treatDisplayNumber(value), "2,5")
        
    }
}










