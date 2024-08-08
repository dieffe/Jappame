//
//  SheetManager.swift
//  Jappame
//
//  Created by fausto.dassenno on 08/08/24.
//

import Foundation

final class SheetManager: ObservableObject {
    enum Action {
        case na
        case present
        case dismiss
    }
    
    @Published private(set) var action: Action = .na
    
    func present () {
        if(self.action == .present) {
            self.dismiss()
        } else {
            self.action = .present
        }
    }
    
    func dismiss() {
        self.action = .dismiss
    }
}

extension SheetManager.Action  {
    var isPresented : Bool {
        self == .present
    }
}
