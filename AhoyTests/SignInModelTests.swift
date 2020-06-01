//
//  SignInModelTests.swift
//  AhoyTests
//
//  Created by Santiago Sanchez merino on 24/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import XCTest
@testable import Ahoy

class SignInModelTests: XCTestCase {
    
    private var dummySignInModel: SignInModel? = nil
    private var wrongSignInModel: SignInModel? = nil
    private var signInModelView: SignInModelView? = nil
    private var view: SignInModelViewProtocol? = nil
    
    override func setUp() {
        dummySignInModel = SignInModel(username: "DummyUsername", password: "dummyPassword")
        wrongSignInModel = SignInModel(username: "", password: "123")
        let signInRepository = LocalRepository()
        signInModelView = SignInModelView(view: nil, signInRepository: signInRepository)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfSignInModelIsNotNull() {
        XCTAssertNotNil(dummySignInModel)
        XCTAssertNotNil(wrongSignInModel)
    }
    
    func testIfSignInModelFieldsAreValid() {
        switch signInModelView?.signInModelIsValid(signInModel: dummySignInModel!) {
        case .success(let val):
            XCTAssertTrue(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(false, "Username is empty")
            case .passwordToShort:
                XCTAssert(false, "Password too short, length must be 10 at least")
            }
        case .none: break
            
        }
    }
    
    func testIfSignInModelFieldsAreInValid() {
        let result = signInModelView?.signInModelIsValid(signInModel: wrongSignInModel!)
        switch result {
        case .success(let val):
            XCTAssertFalse(val)
        case .failure(let error):
            switch error {
            case .usernameEmpty:
                XCTAssert(true, "Username is empty")
            case .passwordToShort:
                XCTAssert(true, "Password too short, length must be 10 at least")
            }
        case .none: break
            
        }
    }
    
    func testIfSignInModelUsernameIsValid() {
        switch signInModelView?.usernameIsValid(username: dummySignInModel?.username ?? "") {
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
    
    func testIfSignInModelUsernameIsInValid() {
        switch signInModelView?.usernameIsValid(username: wrongSignInModel?.username ?? "") {
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
    
    func testIfSignInModelPasswordIsValid() {
        switch signInModelView?.passwordIsValid(password: dummySignInModel?.password ?? "") {
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

    func testIfSignInModelPasswordIsInValid() {
        switch signInModelView?.passwordIsValid(password: wrongSignInModel?.password ?? "") {
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
