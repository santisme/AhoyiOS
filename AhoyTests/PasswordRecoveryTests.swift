//
//  PasswordRecoveryTests.swift
//  AhoyTests
//
//  Created by Santiago Sanchez merino on 28/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import XCTest
@testable import Ahoy

class PasswordRecoveryTests: XCTestCase {
    
    private var dummyPasswordRecoveryModel: PasswordRecoveryModel? = nil
    private var wrongPasswordRecoveryModel: PasswordRecoveryModel? = nil
    private var passwordRecoveryModelView: PasswordRecoveryModelView? = nil
    private var view: PasswordRecoveryModelViewProtocol? = nil
    
    override func setUp() {
        dummyPasswordRecoveryModel = PasswordRecoveryModel(login: "DummyUsername")
        wrongPasswordRecoveryModel = PasswordRecoveryModel(login: "")
        let passwordRecoveryRepository = LocalRepository()
        passwordRecoveryModelView = PasswordRecoveryModelView(view: nil, passwordRecoveryRepository: passwordRecoveryRepository)    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfPasswordRecoveryIsNotNull() {
        XCTAssertNotNil(dummyPasswordRecoveryModel)
        XCTAssertNotNil(wrongPasswordRecoveryModel)
    }
    
    func testIfPasswordRecoveryFieldsAreValid() {
        switch passwordRecoveryModelView?.passwordRecoveryModelIsValid(passwordRecoveryModel: dummyPasswordRecoveryModel!) {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .loginEmpty:
                XCTAssert(false, "Username is empty")
            }
        case .none: break
            
        }
    }
    
    func testIfPasswordRecoveryFieldsAreInValid() {
        let result = passwordRecoveryModelView?.passwordRecoveryModelIsValid(passwordRecoveryModel: wrongPasswordRecoveryModel!)
        switch result {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .loginEmpty:
                XCTAssert(true, "Username is empty")
            }
        case .none: break
            
        }
    }
    
    func testIfPasswordRecoveryUsernameIsValid() {
        switch passwordRecoveryModelView?.loginIsValid(login: (dummyPasswordRecoveryModel)?.login ?? "") {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .loginEmpty:
                XCTAssert(false, "Username is empty")
            }           
        case .none:
            break
        }
    }
    
    func testIfPasswordRecoveryUsernameIsInValid() {
        switch passwordRecoveryModelView?.loginIsValid(login: wrongPasswordRecoveryModel?.login ?? "") {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .loginEmpty:
                XCTAssert(true, "Username is empty")
            }
            
        case .none:
            break
        }
    }
}
