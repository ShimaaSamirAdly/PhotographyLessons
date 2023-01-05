//
//  PhotographyLessonsUITests.swift
//  PhotographyLessonsUITests
//
//  Created by Shimaa on 30/12/2022.
//

import XCTest
@testable import PhotographyLessons

final class PhotographyLessonsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        viewModel = LessonDetailsViewModel(lessonsList: lessonList, selectedLesson: lessonList[0])
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDownloadButton() {
        let downloadBtn = app.buttons["downloadButton"]
        let cancelBtn = app.buttons["cancelButton"]
        let _ = downloadBtn.waitForExistence(timeout: TimeInterval(floatLiteral: 1.0))
        downloadBtn.tap()
        XCTAssertTrue(cancelBtn.exists)
        XCTAssertFalse(downloadBtn.exists)
        cancelBtn.tap()
        XCTAssertTrue(downloadBtn.exists)
        XCTAssertFalse(cancelBtn.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}


