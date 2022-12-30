//
//  LessonRowView.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import SwiftUI
import Kingfisher

struct LessonRowView: View {
    var lesson: LessonModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            KFImage.url(URL(string: lesson.lessonImg))
                .placeholder { _ in
                    ProgressView()
                }.resizable()
                .frame(width: 110, height: 60, alignment: .leading)
                .cornerRadius(5)
            Text(lesson.name)
                .font(.title3)
                .foregroundColor(.white)
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15, alignment: .center)
                .foregroundColor(.accentColor)
                Spacer()
            }
        }.padding(.top, 10)
         .padding(.trailing, 10)
    }
}

struct LessonRowView_Previews: PreviewProvider {
    static var previews: some View {
        LessonRowView(lesson: LessonModel(id: 0, name: "", description: "", lessonImg: "", videoUrl: ""))
    }
}
