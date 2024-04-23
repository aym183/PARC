//
//  UnitTests.swift
//  UnitTests
//
//  Created by Ayman Ali on 20/02/2024.
//

import XCTest
@testable import PARC

final class UnitTests: XCTestCase {
    
    // -- UNIT TESTING --
    // convertDate
    
    func testSuccessfulConvertDate() {
        self.measure {
            let input = "2023-10-02"
            let function = convert_date(dateString: input)
            XCTAssertEqual(function, "02/10/2023")
        }
    }
    
    func testFailureConvertDate() {
        self.measure {
            let input = "02/12/2024"
            let function = convert_date(dateString: input)
            XCTAssertEqual(function, "nil")
        }
    }
    
    func testFailureFormatConvertDate() {
        self.measure {
            let input = "invalid string"
            let function = convert_date(dateString: input)
            XCTAssertEqual(function, "nil")
        }
    }
    
    // isTradingWndowActive
    
    func testScheduledValidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "30/01/2024"
            let status = "Scheduled"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, true)
        }
    }
    
    func testScheduledInvalidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "02/01/2024"
            let status = "Scheduled"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testOngoingValidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "20/01/2024"
            let status = "Ongoing"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, true)
        }
    }
    
    func testOngoingInvalidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "02/01/2024"
            let status = "Ongoing"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testCompletedValidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "20/01/2024"
            let status = "Completed"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testCompletedInvalidTradingWindow() {
        self.measure {
            let target_date = "15/01/2024"
            let start_date = "01/01/2024"
            let end_date = "02/01/2024"
            let status = "Completed"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testInvalidFormatTradingWindowActive() {
        self.measure {
            let target_date = "value"
            let start_date = "value_2"
            let end_date = "value_3"
            let status = "Ongoing"
            
            let function = is_trading_window_active(targetDate: target_date, start: start_date, end: end_date, status: status)
            XCTAssertEqual(function, nil)
        }
    }
    
    // isTradingWndowComplete
    
    func testOngoingValidTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "14/01/2024"
            let status = "Ongoing"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, true)
        }
    }
    
    func testOngoingInvalidTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "16/01/2024"
            let status = "Ongoing"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testScheduledValidTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "14/01/2024"
            let status = "Scheduled"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, true)
        }
    }
    
    func testScheduledInvalidTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "16/01/2024"
            let status = "Scheduled"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testCompletedTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "14/01/2024"
            let status = "Completed"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, false)
        }
    }
    
    func testInvalidFormatTradingWindowComplete() {
        self.measure {
            let target_date = "15/01/2024"
            let end_date = "bad format"
            let status = "Ongoing"
            
            let function = is_trading_window_complete(targetDate: target_date, end: end_date, status: status)
            XCTAssertEqual(function, nil)
        }
    }
    
    // get_days_remaining
    
    func testValidDaysRemaining() {
        self.measure {
            let date_input = "28/04/2024"
            let function = get_days_remaining(date_input: date_input)
            XCTAssertEqual(function, 64)
        }
    }
    
    func testPastDaysRemaining() {
        self.measure {
            let date_input = "20/02/2024"
            let function = get_days_remaining(date_input: date_input)
            XCTAssertEqual(function, 0)
        }
    }
    
    func testEqualDaysRemaining() {
        self.measure {
            // present day
            let date_input = "22/02/2024"
            let function = get_days_remaining(date_input: date_input)
            XCTAssertEqual(function, 0)
        }
    }

    func testInvalidFormatDaysRemaining() {
        self.measure {
            let date_input = "wrong format"
            let function = get_days_remaining(date_input: date_input)
            XCTAssertEqual(function, nil)
        }
    }
    
    // date_string_by_adding_days
    
    func testValidAddingDays() {
        self.measure {
            // valid date and days
            let days = 5
            let date_string = "22/02/2024"
            let function = date_string_by_adding_days(days: days, dateString: date_string)
            XCTAssertEqual(function, "27/02/2024")
        }
    }
    
    func testInvalidZeroAddingDays() {
        self.measure {
            // valid date and invalid days (zero)
            let days = 0
            let date_string = "22/02/2024"
            let function = date_string_by_adding_days(days: days, dateString: date_string)
            XCTAssertEqual(function, date_string)
        }
    }
    
    func testInvalidNegativeAddingDays() {
        self.measure {
            // valid date and invalid days (negative value)
            let days = -2
            let date_string = "22/02/2024"
            let function = date_string_by_adding_days(days: days, dateString: date_string)
            XCTAssertEqual(function, date_string)
        }
    }
  
    func testInvalidDateAddingDays() {
        self.measure {
            // valid days and invalid date
            let days = 10
            let date_string = "wrong date"
            let function = date_string_by_adding_days(days: days, dateString: date_string)
            XCTAssertEqual(function, nil)
        }
    }
    
    // formatted_number
    
    func testValidFormattedNumber() {
        self.measure {
            let input_number = 25000000
            let function = formatted_number(input_number: input_number)
            XCTAssertEqual(function, "25,000,000")
        }
    }
    
    func testNegativeFormattedNumber() {
        self.measure {
            let input_number = -25000000
            let function = formatted_number(input_number: input_number)
            XCTAssertEqual(function, "-25,000,000")
        }
    }
    
    func testZeroFormattedNumber() {
        self.measure {
            let input_number = 0
            let function = formatted_number(input_number: input_number)
            XCTAssertEqual(function, "0")
        }
    }
    
    // calculate_total_value
    
    func testValidCalculateTotalValue() {
        self.measure {
            let input = [["amount": "20"], ["amount": "50"]]
            let field = "amount"
            let function = calculate_total_value(input: input, field: field)
            XCTAssertEqual(function, 70)
        }
    }
    
    func testInvalidArrayCalculateTotalValue() {
        self.measure {
            let input = [["amount": "value"], ["amount": "50"]]
            let field = "amount"
            let function = calculate_total_value(input: input, field: field)
            XCTAssertEqual(function, 50)
        }
    }
    
    func testNullArrayCalculateTotalValue() {
        self.measure {
            let input: [[String: String]] = []
            let field = "amount"
            let function = calculate_total_value(input: input, field: field)
            XCTAssertEqual(function, 0)
        }
    }
    
    func testInvalidFieldCalculateTotalValue() {
        self.measure {
            let input: [[String: String]] = [["amount": "20"], ["amount": "50"]]
            let field = "invalid_amount"
            let function = calculate_total_value(input: input, field: field)
            XCTAssertEqual(function, 0)
        }
    }
    
    // calculate_portion_holdings
    
    func testValidCalculatePortionHoldings() {
        self.measure {
            let input = [["amount": "20000"], ["amount": "15000"], ["amount": "5000"], ["amount": "50000"]]
            let holdings_value = 200000
            let function = calculate_portion_holdings(input: input, holdings_value: holdings_value)
            XCTAssertEqual(function, [10.0, 7.5000005, 2.5, 25.0])
        }
    }
    
    func testInvalidArrayCalculatePortionHoldings() {
        self.measure {
            let input = [["amount": "not a number"], ["amount": "15000"], ["amount": "5000"], ["amount": "50000"]]
            let holdings_value = 200000
            let function = calculate_portion_holdings(input: input, holdings_value: holdings_value)
            XCTAssertEqual(function, [0, 7.5000005, 2.5, 25.0])
        }
    }
    
    // calculate_payout_opportunities
    
    func testValidPayoutOpportunities() {
        self.measure {
            let input = [["opportunity_id": "1", "equity": "2.5"], ["opportunity_id": "2", "equity": "5.75"], ["opportunity_id": "1", "equity": "2.5"], ["opportunity_id": "2", "equity": "2.5"]]
            let function = calculate_payout_opportunities(input: input)
            XCTAssertEqual(function, [2.0, 1.0, 1.0])
        }
    }
    
    func testInvalidPayoutOpportunities() {
        self.measure {
            let input = [["opportunity": "1", "equity": "2.5"], ["opportunity": "2", "equity": "5.75"], ["opportunity": "1", "equity": "2.5"], ["opportunity": "2", "equity": "2.5"]]
            let function = calculate_payout_opportunities(input: input)
            XCTAssertEqual(function, [])
        }
    }
    
    // sort_array_by_date
    
    func testValidSortArray() {
        self.measure {
            let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
            let field_name = "date"
            let date_type = "dd/MM/yyyy"
            let function = sort_array_by_date(inputArray: input_array, field_name: field_name, date_type: date_type)
            XCTAssertEqual(function, [["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "15/02/2024"], ["date": "14/02/2024"]])
        }
    }
    
    func testInvalidFieldSortArray() {
        self.measure {
            // invalid field
            let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
            let field_name = "invalid date field"
            let date_type = "dd/MM/yyyy"
            let function = sort_array_by_date(inputArray: input_array, field_name: field_name, date_type: date_type)
            XCTAssertEqual(function, [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]])
        }
    }
    
    func testInvalidDateTypeSortArray() {
        self.measure {
            // invalid date type
            let input_array = [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]]
            let field_name = "invalid date field"
            let date_type = "yyyy-MM-dd"
            let function = sort_array_by_date(inputArray: input_array, field_name: field_name, date_type: date_type)
            XCTAssertEqual(function, [["date": "15/02/2024"], ["date": "23/02/2024"], ["date": "17/02/2024"], ["date": "14/02/2024"]])
        }
    }
    
    func testInvalidDateValueSortArray() {
        self.measure {
            // invalid date type
            let input_array = [["date": "not a value"], ["date": "23/02/2024"], ["date": "25/02/2024"], ["date": "14/02/2024"]]
            let field_name = "date"
            let date_type = "dd/MM/yyyy"
            let function = sort_array_by_date(inputArray: input_array, field_name: field_name, date_type: date_type)
            XCTAssertEqual(function, [["date": "not a value"], ["date": "25/02/2024"], ["date": "23/02/2024"], ["date": "14/02/2024"]])
        }
    }
 
    // transform_trading_window_data
    
    func testValidTransformTradingWindowData() {
        self.measure {
            // Valid case
            let listed_shares = [["trading_window_id": "1", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
            let function = transform_trading_window_data(listed_shares: listed_shares)
            XCTAssertEqual(function, ["1_trades": 2, "1_volume": 16000])
        }
    }
    
    func testInvalidKeyTransformTradingWindowData() {
        self.measure {
            // Invalid case - key
            let listed_shares = [["trading_window": "1", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
            let function = transform_trading_window_data(listed_shares: listed_shares)
            XCTAssertEqual(function, ["nil": 0])
        }
    }
    
    func testInvalidValueTransformTradingWindowData() {
        self.measure {
            // Invalid case - value
            let listed_shares = [["trading_window_id": "invalid value", "price": "15000"], ["trading_window_id": "1", "price": "1000"]]
            let function = transform_trading_window_data(listed_shares: listed_shares)
            XCTAssertEqual(function, ["invalid value_trades": 1, "invalid value_volume": 15000, "1_volume": 1000, "1_trades": 1])
        }
    }
    
    // transform_payouts
    
    func testValidTransformPayouts() {
        self.measure {
            let payouts_array = [["franchise": "Oodles", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
            let function = transform_payouts(payouts_array: payouts_array)
            XCTAssertEqual(function as NSDictionary, ["Oodles": 27000] as NSDictionary)
        }
    }
    
    func testInvalidKeyTransformPayouts() {
        self.measure {
            let payouts_array = [["invalid key": "Oodles", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
            let function = transform_payouts(payouts_array: payouts_array)
            XCTAssertEqual(function as NSDictionary, ["null": 0] as NSDictionary)
        }
    }
    
    func testInvalidValueTransformPayouts() {
        self.measure {
            let payouts_array = [["franchise": "0", "amount_offered": "25000"], ["franchise": "Oodles", "amount_offered": "2000"]]
            let function = transform_payouts(payouts_array: payouts_array)
            XCTAssertEqual(function as NSDictionary, ["0": 25000, "Oodles": 2000] as NSDictionary)
        }
    }
    
    // sortByDaysRemaining
    
    func testValidSortDaysRemaining() {
        self.measure {
            let array = [["status": "Closed", "close_date": "20/04/2024"], ["status": "Ongoing", "close_date": "15/04/2024"], ["status": "Ongoing", "close_date": "17/04/2024"], ["status": "Ongoing", "close_date": "02/04/2024"]]
            let function = sort_by_days_remaining(array: array)
            XCTAssertEqual(function, [["close_date": "02/04/2024", "status": "Ongoing"], ["close_date": "15/04/2024", "status": "Ongoing"], ["close_date": "17/04/2024", "status": "Ongoing"], ["status": "Closed", "close_date": "20/04/2024"]])
        }
    }
    
    func testInvalidKeySortDaysRemaining() {
        self.measure {
            let array = [["invalid status": "Closed", "close_date": "20/04/2024"], ["invalid status": "Ongoing", "close_date": "15/04/2024"], ["invalid status": "Ongoing", "close_date": "17/04/2024"]]
            let function = sort_by_days_remaining(array: array)
            XCTAssertEqual(function, [["null": "0"]])
        }
    }
    
    func testInvalidValueSortDaysRemaining() {
        self.measure {
            let array = [["status": "Closed", "close_date": "20/04/2024"], ["status": "Ongoing", "close_date": "15/04/2024"], ["status": "Ongoing", "close_date": "17/04/2024"], ["status": "Ongoing", "close_date": "02/04/2024"]]
            let function = sort_by_days_remaining(array: array)
            XCTAssertEqual(function, [["close_date": "02/04/2024", "status": "Ongoing"], ["close_date": "15/04/2024", "status": "Ongoing"], ["status": "Ongoing", "close_date": "17/04/2024"], ["close_date": "20/04/2024", "status": "Closed"]])
        }
    }
    
    // convert_number_amount
    
    func testThousandNumberAmount() {
        self.measure {
            let input_number = 1000.0
            let function = convert_number_amount(input_number: input_number)
            XCTAssertEqual(function, "1k")
        }
    }
    
    func testMillionNumberAmount() {
        self.measure {
            let input_number = 1000000.0
            let function = convert_number_amount(input_number: input_number)
            XCTAssertEqual(function, "1M")
        }
    }
    
    func testBillionNumberAmount() {
        self.measure {
            let input_number = 1000000000.0
            let function = convert_number_amount(input_number: input_number)
            XCTAssertEqual(function, "1B")
        }
    }
    
    func testNumberAmount() {
        self.measure {
            let input_number = 100.0
            let function = convert_number_amount(input_number: input_number)
            XCTAssertEqual(function, "100")
        }
    }

}
