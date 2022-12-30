//
//  ViewExtension.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import Foundation
import SwiftUI

extension View {
    func errorAlert(error: Binding<String>, buttonTitle: String = "OK") -> some View {
        return alert("Error", isPresented: .constant(!(error.wrappedValue.isEmpty))) {
            Button(buttonTitle) {
                error.wrappedValue = ""
            }
        } message: {
            Text(error.wrappedValue)
        }
    }
    
    @ViewBuilder
    func isHidden(hidden: Bool, remove: Bool) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        }else {
            self
        }
    }
}
