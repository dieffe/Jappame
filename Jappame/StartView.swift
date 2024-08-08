//
//  StartView.swift
//  Jappame
//
//  Created by fausto.dassenno on 14/06/24.
//

import SwiftUI

//create an array with the values: Vowels, K-series, S-series, T-series, N-series, H-series, M-series, Y-series, R-series, W-series, Singular
let categories = ["Vowels", "K-series", "S-series", "T-series", "N-series", "H-series", "M-series", "Y-series", "R-series", "W-series", "Singular","G-series","Z-series","D-series","B-series","P-series"]

struct MyModel {
    var id: String
    var name: String
    var notify: Bool
    var score: Int
}


struct SymbolToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark"
    var activeColor: Color = .green

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color(.systemGray5))
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: systemImage)
                                .foregroundColor(configuration.isOn ? activeColor : Color(.systemGray5))
                        }
                        .offset(x: configuration.isOn ? 10 : -10)

                }
                .frame(width: 50, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

struct StartView: View {
    
    @EnvironmentObject var sheetManager: SheetManager
    
    @State var detailSerie : MyModel = MyModel(id: "0", name: "0", notify: false, score: 0)
    
    let defaults = UserDefaults.standard

    @State var myModels: [MyModel] = [
        MyModel(id: "spacer", name: "Basic series", notify: false, score: 0),
        MyModel(id: "1", name: "Vowels", notify: true, score: 0),
        MyModel(id: "2", name: "K-series", notify: false, score: 0),
        MyModel(id: "3", name: "S-series", notify: false, score: 0),
        MyModel(id: "4", name: "T-series", notify: false, score: 0),
        MyModel(id: "5", name: "N-series", notify: false, score: 0),
        MyModel(id: "6", name: "H-series", notify: false, score: 0),
        MyModel(id: "7", name: "M-series", notify: false, score: 0),
        MyModel(id: "8", name: "Y-series", notify: false, score: 0),
        MyModel(id: "9", name: "R-series", notify: false, score: 0),
        MyModel(id: "10", name: "W-series", notify: false, score: 0),
        MyModel(id: "11", name: "Singular", notify: false, score: 0),
        MyModel(id: "spacer", name: "Dakuon", notify: false, score: 0),
        MyModel(id: "12", name: "G-series", notify: false, score: 0),
        MyModel(id: "13", name: "Z-series", notify: false, score: 0),
        MyModel(id: "14", name: "D-series", notify: false, score: 0),
        MyModel(id: "15", name: "B-series", notify: false, score: 0),
        MyModel(id: "16", name: "P-series", notify: false, score: 0)
        
    ]

    
    var body: some View {
        
    NavigationStack {
        
        HStack {
            Spacer()
            Spacer()
            Image(.jappameSigle)
                .padding()
                .frame( alignment: .center)
            Spacer()
            NavigationLink {
                ContentView(series:myModels)
            } label: {
                Text("Start")
            }
            .padding()
            .frame(alignment: .trailing)
        }
        
        ScrollView {
            
            ForEach(0..<myModels.count) { i in
                
                if(self.myModels[i].id=="spacer") {
                    Text(titleRow(iter: i))
                } else {
                    HStack {
                        Toggle(isOn: self.$myModels[i].notify) {
                            Button {
                                self.detailSerie = self.myModels[i]
                                withAnimation {
                                    sheetManager.present()
                                }
                            } label: {
                                Image(systemName: "info.circle")
                                    .tint(Color.green)
                                    .symbolVariant(.circle.fill)
                                    .font(
                                    .system(size: 20,
                                                weight: .bold,
                                                design: .rounded)
                                    )
                            }.padding()
                            
                            Text(titleRow(iter: i))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(Color.blue.opacity(0.7)) // Light blue color
                          
                            //.background(Color.black.opacity(0.1)) // Light background to enhance visibility
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                           
                        }
                        .toggleStyle(SymbolToggleStyle(systemImage: "dot.squareshape.fill", activeColor: .red))
                        .padding(.trailing)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding([.leading, .trailing])
                }
                
            }
            
            //show the version and build within a Text
            Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Color.blue.opacity(0.7))
                .frame(alignment: .center)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
        }.onAppear() {
            //cycle the mymodel array and retrieve the values from the user defaults based on the key as a string
            for i in 0..<myModels.count {
                print(defaults.integer(forKey: "1"))
                self.myModels[i].score = defaults.integer(forKey: myModels[i].id)
            }
        }.overlay(alignment: .bottom) {
            if sheetManager.action.isPresented {
                PopupView(serie: self.detailSerie){
                    withAnimation {
                        sheetManager.dismiss()
                    }
                }
            }
        }.ignoresSafeArea()
        
   
        
        
    }
        

        
    }
    
    func titleRow(iter: Int) -> String {
        if(self.myModels[iter].id=="spacer") {
            return self.myModels[iter].name
        }   else {
            return "🏆"+String(self.myModels[iter].score)+"% "+self.myModels[iter].name
        }
    }
}

#Preview {
    StartView()
        .environmentObject(SheetManager())
}


