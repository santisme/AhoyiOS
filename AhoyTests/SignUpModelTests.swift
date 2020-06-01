//
//  SignUpModelTests.swift
//  AhoyTests
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import XCTest
@testable import Ahoy

class SignUpModelTests: XCTestCase {
    
    private var dummySignUpModel: SignUpModelWrapper? = nil
    private var wrongSignUpModel: SignUpModelWrapper? = nil
    private var signUpModelView: SignUpModelView? = nil
    private var view: SignUpModelViewProtocol? = nil
    
    override func setUp() {
        dummySignUpModel = SignUpModelWrapper(signUpModel: SignUpModel(name: "dummyName", email: "dummyEmail@email.com", password: "1234567890", username: "dummyUsername"), repeatedPassword: "1234567890")
        wrongSignUpModel = SignUpModelWrapper(signUpModel: SignUpModel(name: "dummyName", email: "dummyEmail.com", password: "123", username: ""), repeatedPassword: "12")
        let signUpRepository = LocalRepository()
        signUpModelView = SignUpModelView(view: nil, signUpRepository: signUpRepository)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfSignUpModelIsNotNull() {
        XCTAssertNotNil(dummySignUpModel)
        XCTAssertNotNil(wrongSignUpModel)
    }
    
    func testIfSignUpModelFieldsAreValid() {
        let result = signUpModelView?.signUpModelIsValid(signUpModelWrapper: dummySignUpModel!)
        switch result {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .invalidEmail:
                XCTAssert(false, "Invalid email")
            case .passwordToShort:
                XCTAssert(false, "Password too short, length must be 10 at least")
            case .nonMatchingPasswords:
                XCTAssert(false, "Passwords don't match")
            case .usernameEmpty:
                XCTAssert(false, "Username is empty")
            }
        case .none: break
            
        }
    }
    
    func testIfSignUpModelFieldsAreInValid() {
        let result = signUpModelView?.signUpModelIsValid(signUpModelWrapper: wrongSignUpModel!)
        switch result {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .invalidEmail:
                XCTAssert(true, "Invalid email")
            case .passwordToShort:
                XCTAssert(true, "Password too short, length must be 10 at least")
            case .nonMatchingPasswords:
                XCTAssert(true, "Passwords don't match")
            case .usernameEmpty:
                XCTAssert(true, "Username is empty")
            }
        case .none: break
            
        }
    }
    
    func testIfSignUpModelUsernameIsValid() {
        switch signUpModelView?.usernameIsValid(username: dummySignUpModel?.signUpModel.username ?? "") {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(false, "Username is empty")
            default: break
            }
            
        case .none:
            break
        }
    }

    func testIfSignUpModelUsernameIsInValid() {
        switch signUpModelView?.usernameIsValid(username: wrongSignUpModel?.signUpModel.username ?? "") {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(true, "Username is empty")
            default: break
            }
            
        case .none:
            break
        }
    }

    func testIfSignUpModelEmailIsValid() {
        switch signUpModelView?.emailIsValid(email: dummySignUpModel?.signUpModel.email ?? "") {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(false, "Invalid email")
            default: break
            }
            
        case .none:
            break
        }
    }

    func testIfSignUpModelEmailIsInValid() {
        switch signUpModelView?.emailIsValid(email: wrongSignUpModel?.signUpModel.email ?? "") {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(true, "Invalid email")
            default: break
            }
            
        case .none:
            break
        }
    }
    
    func testIfSignUpModelPasswordIsValid() {
        switch signUpModelView?.passwordIsValid(password: dummySignUpModel?.signUpModel.password ?? "") {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(false, "Password too short, length must be 10 at least")
            default: break
            }
            
        case .none:
            break
        }
    }

    func testIfSignUpModelPasswordIsInValid() {
        switch signUpModelView?.passwordIsValid(password: wrongSignUpModel?.signUpModel.password ?? "") {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(true, "Password too short, length must be 10 at least")
            default: break
            }
            
        case .none:
            break
        }
    }
    
    func testIfSignUpModelRepeatedPasswordIsValid() {
        switch signUpModelView?.repeatPasswordIsValid(password: dummySignUpModel?.signUpModel.password ?? "", repeatedPassword: dummySignUpModel?.repeatedPassword ?? "") {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(false, "Password too short, length must be 10 at least")
            default: break
            }
            
        case .none:
            break
        }
    }

    func testIfSignUpModelRepeatedPasswordIsInValid() {
        switch signUpModelView?.repeatPasswordIsValid(password: wrongSignUpModel?.signUpModel.password ?? "", repeatedPassword: wrongSignUpModel?.repeatedPassword ?? "") {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(true, "Password too short, length must be 10 at least")
            default: break
            }
            
        case .none:
            break
        }
    }
}
