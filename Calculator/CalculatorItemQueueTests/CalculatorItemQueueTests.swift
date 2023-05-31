//
//  CalculatorItemQueueTests.swift
//  CalculatorItemQueueTests
//
//  Created by EtialMoon on 2023/05/30.
//

import XCTest
@testable import Calculator

final class CalculatorItemQueueTests: XCTestCase {
    var sut: CalculatorItemQueue!

    override func setUpWithError() throws {
        sut = CalculatorItemQueue()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_init에1_2_3을넣으면_enqueuedCalculatorItems에1_2_3이있다() {
        let input = [1, 2, 3]
        
        sut = CalculatorItemQueue(input)
        let result = sut.enqueuedCalculatorItems as? [Int]
        
        XCTAssertEqual(input, result)
    }
    
    func test_enqueue에1을넣으면_enqueuedCalculatorItems에1이있다() {
        let input = 1
        
        sut.enqueue(input)
        let result = sut.enqueuedCalculatorItems.first as? Int
        
        XCTAssertEqual(input, result)
    }
    
    func test_enqueue에더하기기호를넣으면_enqueuedCalculatorItems에더하기기호가있다() {
        let input = "+"
        
        sut.enqueue(input)
        let result = sut.enqueuedCalculatorItems.first as? String
        
        XCTAssertEqual(input, result)
    }
    
    func test_enqueuedCalculatorItems에1이있으면_dequeue를했을때_1이반환된다() {
        sut = CalculatorItemQueue([1])
        let expectation = 1
        
        let result = sut.dequeue() as? Int
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_enqueuedCalculatorItems에더하기기호가있으면_dequeue를했을때_더하기기호가반환된다() {
        sut = CalculatorItemQueue(["+"])
        let expectation = "+"
        
        let result = sut.dequeue() as? String
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_enqueuedCalculatorItems에1이있으면_dequeue를했을때_enqueuedCalculatorItems가비어있다() {
        sut = CalculatorItemQueue([1])
        
        sut.dequeue()
        let result = sut.enqueuedCalculatorItems.isEmpty
        
        XCTAssertTrue(result)
    }
    
    func test_dequeueCalculatorItems가비어있으면_dequeue를했을때_nil을반환한다() {
        let result = sut.dequeue()
        
        XCTAssertNil(result)
    }
    
    func test_dequeueCalculatorItems가비어있으면_dequeue했을때_enqueuedCalculatorItems가비어있다() {
        sut.dequeue()
        let result = sut.enqueuedCalculatorItems.first
        
        XCTAssertNil(result)
    }
}
