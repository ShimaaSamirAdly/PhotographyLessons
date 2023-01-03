//
//  LessonsListView+Handler.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation
import CoreData
import Combine

extension LessonsListView {
    @MainActor
    class LessonsListViewHandler: ObservableObject {
        private var lessonsUseCase = GetLessonsUseCase(repo: LessonsRepoImpl())
        private var cacheLessonsUseCase = CacheLessonsUseCase(repo: LessonCachingRepoImpl())
        @Published var errorMsg = ""
        @Published var isLoading = false
        @Published var showCachedData = false
        @Published var newData = false
//        let dm = DownloadManager()
        var cancellableSet = Set<AnyCancellable>()
        
        func getLessons() async -> [LessonModel] {
        
//                let download = dm.downloadFile(withUrl: URL(string: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")!)
//            download.sink { completion in
//                switch completion {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    //                    print("error is \(error)")
//                case .finished:
//                    print("finished without errors")
//                }
//            } receiveValue: { url in
//                print(url)
//            }.store(in: &cancellableSet)

            
            isLoading = true
            let response = await lessonsUseCase.getLessons()
            isLoading = false
            errorMsg = response.1
            let lessons = response.0
            cacheLessonsUseCase.cachLessons(lessons: lessons)
            showCachedData = lessons.isEmpty
            newData = !lessons.isEmpty
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                Task {
//                    await self.dm.cancelDownload(withUrl: URL(string: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")!)
//                }
//            }
            return lessons
        }
        
        func getCachedLessons(cachedLessons: [Lesson]) -> [LessonModel] {
            let lessons = cachedLessons.map({
                LessonModel(id: Int($0.id), name: $0.name ?? "", description: $0.desc ?? "", lessonImg: $0.lessonImg ?? "", videoUrl: $0.videoUrl ?? "")
            })
            showCachedData = false
            return lessons
        }
    }
}
