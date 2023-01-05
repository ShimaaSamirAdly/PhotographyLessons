//
//  LessonDetailsTests.swift
//  PhotographyLessonsTests
//
//  Created by Shimaa on 05/01/2023.
//

import XCTest
import Combine
@testable import PhotographyLessons

final class LessonDetailsTests: XCTestCase {
    
    var lessonDetailsViewModelMock: LessonDetailsViewModelMock?
    var repo: DownloadRepoMockImpl?
    var lessons: [LessonModel]?
    var selectedLesson: LessonModel?
    private var cancellables: Set<AnyCancellable>?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        lessons = [LessonModel(id: 0, name: "firstLesson", description: "", lessonImg: "", videoUrl: ""),
                   LessonModel(id: 1, name: "secondLesson", description: "", lessonImg: "", videoUrl: "")]
        selectedLesson = lessons?[0]
        guard let lessons = lessons, let selectedLesson = selectedLesson else { return }
        lessonDetailsViewModelMock = LessonDetailsViewModelMock(lessonsList: lessons, selectedLesson: selectedLesson)
        repo = DownloadRepoMockImpl()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        lessons = nil
        selectedLesson = nil
        lessonDetailsViewModelMock = nil
        repo = nil
        try super.tearDownWithError()
    }
    
    func testSetNextLesson() {
        lessonDetailsViewModelMock?.setNextLesson()
        XCTAssertTrue(lessonDetailsViewModelMock?.getLessonTitle() == lessons?[1].name)
    }
    
    func testProgressWhileDownloading() async {
        guard let repo = repo else { return }
        repo.isDownloading = true
        lessonDetailsViewModelMock?.observeProgressUseCase = ObserveDownloadProgress(repo: repo)
        var progressCount = 0.0
        let expectations = expectation(description: "progressWhileDownload")
        await lessonDetailsViewModelMock?.observeProgressUseCase?.repo.observeDownloadProgress(forTaskUrl: URL(filePath: ""))?.sink(receiveValue: { value in
            progressCount = value
            expectations.fulfill()
        }).store(in: &cancellables!)
        wait(for: [expectations], timeout: 2)
        XCTAssertTrue(progressCount > 0.0)
    }
    
    func testProgressWhileNoDownloading() async {
        guard let repo = repo else { return }
        repo.isDownloading = false
        lessonDetailsViewModelMock?.observeProgressUseCase = ObserveDownloadProgress(repo: repo)
        var progressCount = 0.0
        let expectations = expectation(description: "progressWhileDownload")
        await lessonDetailsViewModelMock?.observeProgressUseCase?.repo.observeDownloadProgress(forTaskUrl: URL(filePath: ""))?.sink(receiveValue: { value in
            progressCount = value
            expectations.fulfill()
        }).store(in: &cancellables!)
        wait(for: [expectations], timeout: 2)
        XCTAssertTrue(progressCount == 0.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
