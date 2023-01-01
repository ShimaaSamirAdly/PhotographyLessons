//
//  LessonDetailsView.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import SwiftUI
import AVFoundation
import AVKit

struct LessonDetailsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailsViewController
    var lessonsList: [LessonModel]
    var selectedLesson: LessonModel
    
    func makeUIViewController(context: Context) -> LessonDetailsViewController {
        let lessonDetailsVC = LessonDetailsViewController()
        let lessonDetailsViewModel = LessonDetailsViewModel(lessonsList: lessonsList, selectedLesson: selectedLesson)
        lessonDetailsVC.viewModel = lessonDetailsViewModel
        return lessonDetailsVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
