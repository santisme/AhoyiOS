//
//  LocalRepositoryTests.swift
//  AhoyTests
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import XCTest

//
//  LocalRepositoryTests.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 16/09/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import XCTest
@testable import Ahoy

class LocalRepositoryTests: XCTestCase {

    private var repository: LocalRepository? = nil
    
    override func setUp() {
        repository = Repository.factory

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalRepositoryExistence() {
        XCTAssertNotNil(repository)
    }

    func testLocalRepositoryInitDatabase() {
        do {
            try repository?.initDefaultData()
            XCTAssert(true)
        } catch {
            XCTAssert(false)
            print("Error Initializing local repository database: \(error.localizedDescription)")
        }
    }
    
    func testLocalRepositoryInitDiscourseCategoryDefaultData() {
        do {
            try repository?.initDiscourseCategoryDefaultData()
            XCTAssert(true)
        } catch {
            XCTAssert(false)
            print("Error Initializing local repository DiscourseCategory: \(error.localizedDescription)")
        }
    }
    
    func testLocalRepositoryFetchDiscourseCategoryList() {
        let expectations = expectation(description: "testLocalRepositoryFetchDiscourseCategoryList")

        repository?.fetchDiscourseCategoryList { result in
            switch result {
            case .success(let value):
                print("\(value.discourseCategoryList.discourseCategories)")
                expectations.fulfill()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
        
}

