//
//  JappameApp.swift
//  Jappame
//
//  Created by fausto.dassenno on 12/06/24.
//

import SwiftUI

@main
struct JappameApp: App {

    @StateObject var sheetManager = SheetManager()
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(sheetManager)
        }
    }
}
