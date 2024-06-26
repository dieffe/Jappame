//
//  StartView.swift
//  Jappame
//
//  Created by fausto.dassenno on 14/06/24.
//

import SwiftUI

//create an array with the values: Vowels, K-series, S-series, T-series, N-series, H-series, M-series, Y-series, R-series, W-series, Singular
let categories = ["Vowels", "K-series", "S-series", "T-series", "N-series", "H-series", "M-series", "Y-series", "R-series", "W-series", "Singular"]

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
    
    let defaults = UserDefaults.standard

    @State var myModels: [MyModel] = [
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
        MyModel(id: "11", name: "Singular", notify: false, score: 0)
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
                HStack {
                    Toggle(isOn: self.$myModels[i].notify) {
                        Text(titleRow(iter: i))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color.blue.opacity(0.7)) // Light blue color
                            .padding()
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
            
        }.onAppear() {
            //cycle the mymodel array and retrieve the values from the user defaults based on the key as a string
            for i in 0..<myModels.count {
                print(defaults.integer(forKey: "1"))
                self.myModels[i].score = defaults.integer(forKey: myModels[i].id)
            }
        }
    
        
    }
        

        
    }
    
    func titleRow(iter: Int) -> String {
        return "🏆"+String(self.myModels[iter].score)+"% "+self.myModels[iter].name
    }
}

#Preview {
    StartView()
}


