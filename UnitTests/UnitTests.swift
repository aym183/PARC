//
//  UnitTests.swift
//  UnitTests
//
//  Created by Ayman Ali on 20/02/2024.
//

import XCTest
@testable import PARC

final class UnitTests: XCTestCase {
    
    // convertDate
    
    func testSuccessfulConvertDate() {
        let input = "2023-10-02"
        let function = convertDate(dateString: input)
        XCTAssertEqual(function, "02/10/2023")
    }
    
    func testFailureConvertDate() {
        let input = "02/12/2024"
        let function = convertDate(dateString: input)
        XCTAssertEqual(function, "nil")
    }
    
    func testFailureFormatConvertDate() {
        let input = "invalid string"
        let function = convertDate(dateString: input)
        XCTAssertEqual(function, "nil")
    }
    
    // isTradingWndowActive
    
    func testScheduledValidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "30/01/2024"
        let status = "Scheduled"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, true)
    }
    
    func testScheduledInvalidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "02/01/2024"
        let status = "Scheduled"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testOngoingValidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "20/01/2024"
        let status = "Ongoing"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, true)
    }
    
    func testOngoingInvalidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "02/01/2024"
        let status = "Ongoing"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testCompletedValidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "20/01/2024"
        let status = "Completed"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testCompletedInvalidTradingWindow() {
        let target_date = "15/01/2024"
        let start_date = "01/01/2024"
        let end_date = "02/01/2024"
        let status = "Completed"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testInvalidFormatTradingWindowActive() {
        let target_date = "value"
        let start_date = "value_2"
        let end_date = "value_3"
        let status = "Ongoing"
        
        let function = isTradingWindowActive(targetDate: target_date, start: start_date, end: end_date, status: status)
        XCTAssertEqual(function, nil)
    }
    
    // isTradingWndowComplete
    
    func testOngoingValidTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "14/01/2024"
        let status = "Ongoing"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, true)
    }
    
    func testOngoingInvalidTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "16/01/2024"
        let status = "Ongoing"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testScheduledValidTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "14/01/2024"
        let status = "Scheduled"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, true)
    }
    
    func testScheduledInvalidTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "16/01/2024"
        let status = "Scheduled"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testCompletedTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "14/01/2024"
        let status = "Completed"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, false)
    }
    
    func testInvalidFormatTradingWindowComplete() {
        let target_date = "15/01/2024"
        let end_date = "bad format"
        let status = "Ongoing"
        
        let function = isTradingWindowComplete(targetDate: target_date, end: end_date, status: status)
        XCTAssertEqual(function, nil)
    }
    
    // getDaysRemaining
    
    func testValidDaysRemaining() {
        let date_input = "28/04/2024"
        let function = getDaysRemaining(date_input: date_input)
        XCTAssertEqual(function, 65)
    }
    
    func testPastDaysRemaining() {
        let date_input = "20/02/2024"
        let function = getDaysRemaining(date_input: date_input)
        XCTAssertEqual(function, 0)
    }
    
    func testEqualDaysRemaining() {
        // present day
        let date_input = "22/02/2024"
        let function = getDaysRemaining(date_input: date_input)
        XCTAssertEqual(function, 0)
    }

    func testInvalidFormatDaysRemaining() {
        let date_input = "wrong format"
        let function = getDaysRemaining(date_input: date_input)
        XCTAssertEqual(function, nil)
    }
    
    // dateStringByAddingDays
    
    func testValidAddingDays() {
        // valid date and days
        let days = 5
        let date_string = "22/02/2024"
        let function = dateStringByAddingDays(days: days, dateString: date_string)
        XCTAssertEqual(function, "27/02/2024")
    }
    
    func testInvalidZeroAddingDays() {
        // valid date and invalid days (zero)
        let days = 0
        let date_string = "22/02/2024"
        let function = dateStringByAddingDays(days: days, dateString: date_string)
        XCTAssertEqual(function, date_string)
    }
    
    func testInvalidNegativeAddingDays() {
        // valid date and invalid days (negative value)
        let days = -2
        let date_string = "22/02/2024"
        let function = dateStringByAddingDays(days: days, dateString: date_string)
        XCTAssertEqual(function, date_string)
    }
  
    func testInvalidDateAddingDays() {
        // valid days and invalid date
        let days = 10
        let date_string = "wrong date"
        let function = dateStringByAddingDays(days: days, dateString: date_string)
        XCTAssertEqual(function, nil)
    }
    
    // formattedNumber
    
    func testValidFormattedNumber() {
        let input_number = 25000000
        let function = formattedNumber(input_number: input_number)
        XCTAssertEqual(function, "25,000,000")
    }
    
    func testNegativeFormattedNumber() {
        let input_number = -25000000
        let function = formattedNumber(input_number: input_number)
        XCTAssertEqual(function, "-25,000,000")
    }
    
    func testZeroFormattedNumber() {
        let input_number = 0
        let function = formattedNumber(input_number: input_number)
        XCTAssertEqual(function, "0")
    }
    
    // calculateTotalValue
    
    func testValidCalculateTotalValue() {
        let input = [["amount": "20"], ["amount": "50"]]
        let field = "amount"
        let function = calculateTotalValue(input: input, field: field)
        XCTAssertEqual(function, 70)
    }
    
    func testInvalidArrayCalculateTotalValue() {
        let input = [["amount": "value"], ["amount": "50"]]
        let field = "amount"
        let function = calculateTotalValue(input: input, field: field)
        XCTAssertEqual(function, 50)
    }
    
    func testNullArrayCalculateTotalValue() {
        let input: [[String: String]] = []
        let field = "amount"
        let function = calculateTotalValue(input: input, field: field)
        XCTAssertEqual(function, 0)
    }
    
    func testInvalidFieldCalculateTotalValue() {
        let input: [[String: String]] = [["amount": "20"], ["amount": "50"]]
        let field = "invalid_amount"
        let function = calculateTotalValue(input: input, field: field)
        XCTAssertEqual(function, 0)
    }
    
    // calculatePortionHoldings
    
    func testValidCalculatePortionHoldings() {
        let input = [["amount": "20000"], ["amount": "15000"], ["amount": "5000"], ["amount": "50000"]]
        let holdings_value = 200000
        let function = calculatePortionHoldings(input: input, holdings_value: holdings_value)
        XCTAssertEqual(function, [10.0, 7.5000005, 2.5, 25.0])
    }
    
    func testInvalidArrayCalculatePortionHoldings() {
        let input = [["amount": "not a number"], ["amount": "15000"], ["amount": "5000"], ["amount": "50000"]]
        let holdings_value = 200000
        let function = calculatePortionHoldings(input: input, holdings_value: holdings_value)
        XCTAssertEqual(function, [0, 7.5000005, 2.5, 25.0])
    }
    
    // calculatePayoutOpportunities
    
    func testValidPayoutOpportunities() {
        let input = [["opportunity_id": "1", "equity": "2.5"], ["opportunity_id": "2", "equity": "5.75"], ["opportunity_id": "1", "equity": "2.5"], ["opportunity_id": "2", "equity": "2.5"]]
        let function = calculatePayoutOpportunities(input: input)
        XCTAssertEqual(function, [2.0, 1.0, 1.0])
    }
    
    func testInvalidPayoutOpportunities() {
        let input = [["opportunity": "1", "equity": "2.5"], ["opportunity": "2", "equity": "5.75"], ["opportunity": "1", "equity": "2.5"], ["opportunity": "2", "equity": "2.5"]]
        let function = calculatePayoutOpportunities(input: input)
        XCTAssertEqual(function, [])
    }
    
    // sortArrayByDate
    
    func testValidSortArray() {
        let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
        let field_name = "date"
        let date_type = "dd/MM/yyyy"
        let function = sortArrayByDate(inputArray: input_array, field_name: field_name, date_type: date_type)
        XCTAssertEqual(function, [["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "15/02/2024"], ["date": "14/02/2024"]])
    }
    
    func testInvalidFieldSortArray() {
        // invalid field
        let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
        let field_name = "invalid date field"
        let date_type = "dd/MM/yyyy"
        let function = sortArrayByDate(inputArray: input_array, field_name: field_name, date_type: date_type)
        XCTAssertEqual(function, [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]])
    }
    
    func testInvalidDateTypeSortArray() {
        // invalid date type
        let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
        let field_name = "invalid date field"
        let date_type = "yyyy-MM-dd"
        let function = sortArrayByDate(inputArray: input_array, field_name: field_name, date_type: date_type)
        XCTAssertEqual(function, [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]])
    }
    
    func testInvalidDateValueSortArray() {
        // invalid date type
        let input_array = [["date": "not a value"], ["date": "23/02/2024"], ["date": "25/02/2024"], ["date": "14/02/2024"]]
        let field_name = "date"
        let date_type = "dd/MM/yyyy"
        let function = sortArrayByDate(inputArray: input_array, field_name: field_name, date_type: date_type)
        XCTAssertEqual(function, [["date": "not a value"], ["date": "25/02/2024"], ["date": "23/02/2024"], ["date": "14/02/2024"]])
    }
    
    // transformListedShares
    
//    func testValidListedShares() {
//        let listed_shares = ["Starbucks": [["amount": "1000", "opportunity_name": "Starbucks"]]]
//        let function = transformListedShares(listed_shares: listed_shares)
//        
//        XCTAssertIdentical(function, [(key: "Starbucks", value: 1000)])
////        (function, )
//    }
 
    // transformTradingWindowData
    
    func testValidTransformTradingWindowData() {
        // Valid case
        let listed_shares = [["trading_window_id": "1", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
        let function = transformTradingWindowData(listed_shares: listed_shares)
        
        XCTAssertEqual(function, ["1_trades": 2, "1_volume": 16000])
    }
    
    func testInvalidKeyTransformTradingWindowData() {
        // Invalid case - key
        let listed_shares = [["trading_window": "1", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
        let function = transformTradingWindowData(listed_shares: listed_shares)
        
        XCTAssertEqual(function, ["nil": 0])
    }
    
    func testInvalidValueTransformTradingWindowData() {
        // Invalid case - value
        let listed_shares = [["trading_window_id": "invalid value", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
        let function = transformTradingWindowData(listed_shares: listed_shares)
        
        XCTAssertEqual(function, ["invalid value_trades": 1, "invalid value_volume": 15000, "1_volume": 1000, "1_trades": 1])
    }
    
    // transformPayouts
    
    func testValidTransformPayouts() {
        let payouts_array = [["franchise": "Oodles", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
        let function = transformPayouts(payouts_array: payouts_array)
        XCTAssertEqual(function as NSDictionary, ["Oodles": 27000] as NSDictionary)
    }
    
    func testInvalidKeyTransformPayouts() {
        let payouts_array = [["invalid key": "Oodles", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
        let function = transformPayouts(payouts_array: payouts_array)
        XCTAssertEqual(function as NSDictionary, ["null": 0] as NSDictionary)
    }
    
    func testInvalidValueTransformPayouts() {
        let payouts_array = [["franchise": "0", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
        let function = transformPayouts(payouts_array: payouts_array)
        XCTAssertEqual(function as NSDictionary, ["0": 25000, "Oodles": 2000] as NSDictionary)
    }
    
    // sortByDaysRemaining
    
    func testValidSortDaysRemaining() {
        let array = [["status": "Closed", "close_date": "20/04/2024"], ["status": "Ongoing", "close_date": "15/04/2024"], ["status": "Ongoing", "close_date": "17/04/2024"], ["status": "Ongoing", "close_date": "02/04/2024"]]
        let function = sortByDaysRemaining(array: array)
        XCTAssertEqual(function, [["close_date": "02/04/2024", "status": "Ongoing"], ["close_date": "15/04/2024", "status": "Ongoing"], ["close_date": "17/04/2024", "status": "Ongoing"], ["status": "Closed", "close_date": "20/04/2024"]])
    }
    
    func testInvalidKeySortDaysRemaining() {
        let array = [["invalid status": "Closed", "close_date": "20/04/2024"], ["invalid status": "Ongoing", "close_date": "15/04/2024"], ["invalid status": "Ongoing", "close_date": "17/04/2024"]]
        let function = sortByDaysRemaining(array: array)
        XCTAssertEqual(function, [["null": "0"]])
    }
    
    func testInvalidValueSortDaysRemaining() {
        let array = [["status": "Closed", "close_date": "20/04/2024"], ["status": "Ongoing", "close_date": "15/04/2024"], ["status": "Ongoing", "close_date": "17/04/2024"], ["status": "Ongoing", "close_date": "02/04/2024"]]
        let function = sortByDaysRemaining(array: array)
        XCTAssertEqual(function, [["close_date": "02/04/2024", "status": "Ongoing"], ["close_date": "15/04/2024", "status": "Ongoing"], ["status": "Ongoing", "close_date": "17/04/2024"], ["close_date": "20/04/2024", "status": "Closed"]])
    }
    
    // convertNumberAmount
    
    func testThousandNumberAmount() {
        let input_number = 1000.0
        let function = convertNumberAmount(input_number: input_number)
        XCTAssertEqual(function, "1k")
    }
    
    func testMillionNumberAmount() {
        let input_number = 1000000.0
        let function = convertNumberAmount(input_number: input_number)
        XCTAssertEqual(function, "1M")
    }
    
    func testBillionNumberAmount() {
        let input_number = 1000000000.0
        let function = convertNumberAmount(input_number: input_number)
        XCTAssertEqual(function, "1B")
    }
    
    func testNumberAmount() {
        let input_number = 100.0
        let function = convertNumberAmount(input_number: input_number)
        XCTAssertEqual(function, "100")
    }
    
    // Test functions in individual files
}
