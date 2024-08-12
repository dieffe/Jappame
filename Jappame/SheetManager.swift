//
//  SheetManager.swift
//  Jappame
//
//  Created by fausto.dassenno on 08/08/24.
//

import Foundation

final class SheetManager: ObservableObject {
    
    typealias Config  = Action.Info
    
    enum Action {
        
        struct Info {
            let series: [String]
        }
        
        case na
        case present(info: Info)
        case dismiss
    }
    
    @Published private(set) var action: Action = .na
    
    func present (with config: Config) {
        //if(self.action == .present(_)) {
        //    self.dismiss()
        //} else {
            self.action = .present(info: config)
        //}
    }
    
    func dismiss() {
        self.action = .dismiss
    }
    
}

extension SheetManager.Action  {
    var isPresented : Bool {
        guard case .present(_) = self else { return false }
        return true
    }
}
