//
//  PhotographyLessonsTests.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 30/12/2022.
//

import XCTest
@testable import PhotographyLessons

@MainActor
final class LessonsListTests: XCTestCase {
    
    var lessonsListHandlerMock: LessonListHandlerMock?
    var repo: LessonRepoMockImpl?
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        lessonsListHandlerMock = LessonListHandlerMock()
        repo = LessonRepoMockImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        lessonsListHandlerMock = nil
        repo = nil
        try super.tearDownWithError()
    }
    
    func testGetLessonsWithInternet() async {
        guard let lessonsListHandlerMock = lessonsListHandlerMock, let repo = repo else { return }
        lessonsListHandlerMock.useCase = GetLessonsUseCase(repo: repo)
        let lessons = await lessonsListHandlerMock.getLessons()
        XCTAssertTrue(lessons.count == 1)
        XCTAssertTrue(lessonsListHandlerMock.callCacheLessons)
        XCTAssertTrue(lessonsListHandlerMock.errorMsg.isEmpty)
        XCTAssertTrue(!lessonsListHandlerMock.showCachedData)
    }
    
    func testGetLessonsWithNoInternet() async {
        repo?.noInternet = true
        guard let lessonsListHandlerMock = lessonsListHandlerMock, let repo = repo else { return }
        lessonsListHandlerMock.useCase = GetLessonsUseCase(repo: repo)
        let lessons = await lessonsListHandlerMock.getLessons()
        XCTAssertTrue(lessons.isEmpty)
        XCTAssertTrue(!lessonsListHandlerMock.callCacheLessons)
        XCTAssertTrue(!lessonsListHandlerMock.errorMsg.isEmpty)
        XCTAssertTrue(lessonsListHandlerMock.showCachedData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
