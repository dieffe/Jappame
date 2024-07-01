//
//  ContentView.swift
//  Jappame
//
//  Created by fausto.dassenno on 12/06/24.
//
import ConfettiSwiftUI
import SwiftUI
import AVFoundation



//create an array with key an integer and value a list of Hiragana vowels
let chars = [
    1: ["あ", "い", "う", "え", "お"],
    2: ["か", "き", "く", "け", "こ"],
    3: ["さ", "し", "す", "せ", "そ"],
    4: ["た", "ち", "つ", "て", "と"],
    5: ["な", "に", "ぬ", "ね", "の"],
    6: ["は", "ひ", "ふ", "へ", "ほ"],
    7: ["ま", "み", "む", "め", "も"],
    8: ["や", "ゆ", "よ"],
    9: ["ら", "り", "る", "れ", "ろ"],
    10: ["わ", "を", "ん"],
    11: ["ん"]
]

struct ContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    //sounds
    @State private var player: AVAudioPlayer?
    @State private var selectedSound: String = "si"
    
    let soundNames = ["si", "no"]

    
    let series: [MyModel]

    @State var buttonText = "な"
    @State var correctAnswer = "a"
    //create an array as a state
    @State var textArray = ["-","-","-","-"]
    @State var answers = ["","","",""]
    @State private var counter: Int = 0
    
    @State var score: Int = 0
    @State var askedQuestions: Int = 0
    var totalQuestions = 10
    @State var isShowingView = false
    @State private var showingAlert = false

    @State var selectedSeries:[Int] = []

    @State var colori: [Color] = [.blue,.blue,.blue,.blue]
    
    let text1 = NSAttributedString(string: "な", attributes: [
        .languageIdentifier: "na",                            // << this !!
        .font: UIFont.systemFont(ofSize: 64)
    ])
    
    var body: some View {
        
        ZStack {
            VStack {
                //--->
                HStack {
                    
                    Image(.jappameSigle).padding()
                    Spacer()
                    Text("\(score)/\(askedQuestions)").padding()
                        .font(
                            .system(size: 30)
                            .weight(.heavy)
                        )
                        .foregroundColor(.blue)
                    
                }
                
                Spacer()
                
                VStack {
                    Button(buttonText) {
                        
                    }.font(.system(size: 150))
                    
                }
                .padding()
                .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Come on..."),
                                message: Text("Choose at least one more serie"),
                                primaryButton: .destructive(Text("Got it")) {
                                    dismiss()
                                }, secondaryButton: .default(Text("Ok")) {
                                    dismiss()
                                }
                            )
                        }
                
                let columns = [
                    GridItem(.adaptive(minimum: 150))
                ]
                
                LazyVGrid(columns: columns, content: {
                    ForEach(0..<4) { number in
                        let option = answers[number]
                        
                        HStack {
                            Button() {
                                if(correctAnswer==option) {
                                    selectedSound = "si"
                                    playSound()
                                    counter += 1
                                    score += 1
                                    colori[number] = .green
                                } else {
                                    selectedSound = "no"
                                    playSound()
                                    colori[number] = .red
                                }
                                askedQuestions += 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    buttonText=" "
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    if(askedQuestions>=totalQuestions) {
                                        calcAndSaveScore()
                                        isShowingView = true
                                    } else {
                                        getNext()
                                        colori = [.blue,.blue,.blue,.blue]
                                    }
                                }
                                
                            } label: {
                                Text(option)
                                    .frame(minWidth:100)
                            }
                            
                            .font(.system(size: 50))
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle)
                            .controlSize(.large)
                            .padding()
                            .tint(colori[number])
                            .confettiCannon(counter: $counter, colors: [.red, .black], confettiSize: 20)
                            
                        }
                        
                    }
                })
                .padding(.horizontal)
                .onAppear {
                    textArray.removeAll()
                    //cycle all the series and if notify is true, get the corresponding list of characters and generate a final array
                    for serie in series {
                        if serie.notify {
                            //cast an integer from serie.id
                            let quale = Int(serie.id)!
                            selectedSeries.append(quale)
                            let serieChars = chars[quale]
                            //cycle the list of characters and add them to the textArray
                            for char in serieChars! {
                                textArray.append(char)
                            }
                        }
                    }
                    if(textArray.count<4) {
                        showingAlert.toggle()
                    } else {
                        getNext()
                    }
                }
                Spacer()
            }
            
            
            if isShowingView {
                Group {
                    ZStack {
                        ZStack {
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.8))
                        
                        VStack {
                            Text("Done!")
                                .font(.system(size: 30))
                                .foregroundColor(.green)
                                .padding()
                            Text("\(score) / \(askedQuestions)")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                                .bold()
                                .padding()
                            Button("Continue") {
                                dismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle)
                        }
                        .frame(width: 200.0, height: 200.0)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 10)
                        
                    }
                }
            }
            
        }
        
    
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: selectedSound, withExtension: "mp3") else {
          return
        }

        do {
          player = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
          print("Failed to load the sound: \(error)")
        }
        player?.play()
    }
    
    func calcAndSaveScore() -> Int {
        let final_score:Double = (Double(score)/Double(askedQuestions))*100
        for sel in selectedSeries {
            saveScore(score: Int(final_score), serie: sel)
        }
        return Int(final_score)
    }

    //a function that get the series id from the UserDefault, calculate the average between it and a passed score and saves it back to the UserDefault
    func saveScore(score: Int, serie: Int) {
        let defaults = UserDefaults.standard
        let key = String(serie)
        let savedScore = defaults.integer(forKey: key)
        var calc_score = 0
        if savedScore > 0 {
            calc_score = (savedScore + score) / 2
        } else {
            calc_score = score
        }
        print(calc_score)
        defaults.set(calc_score, forKey: key)
        //print the content of the key in the UserDefault
        print(defaults.integer(forKey: key))
    }

    
    func getNext(){
        
        answers.removeAll()

        let person = [
                    //list the bacis hiragana characters and their corresponding romaji
                    "あ": "a",
                    "い": "i",
                    "う": "u",
                    "え": "e",
                    "お": "o",
                    "か": "ka",
                    "き": "ki",
                    "く": "ku",
                    "け": "ke",
                    "こ": "ko",
                    "さ": "sa",
                    "し": "shi",
                    "す": "su",
                    "せ": "se",
                    "そ": "so",
                    "た": "ta",
                    "ち": "chi",
                    "つ": "tsu",
                    "て": "te",
                    "と": "to",
                    "な": "na",
                    "に": "ni",
                    "ぬ": "nu",
                    "ね": "ne",
                    "の": "no",
                    "は": "ha",
                    "ひ": "hi",
                    "ふ": "fu",
                    "へ": "he",
                    "ほ": "ho",
                    "ま": "ma",
                    "み": "mi",
                    "む": "mu",
                    "め": "me",
                    "も": "mo",
                    "や": "ya",
                    "ゆ": "yu",
                    "よ": "yo",
                    "ら": "ra",
                    "り": "ri",
                    "る": "ru",
                    "れ": "re",
                    "ろ": "ro",
                    "わ": "wa",
                    "を": "wo",
                    "ん": "n"
        ]
        //choose a random key
        let randomKey = textArray.randomElement()
        //get the value of the key
        correctAnswer = person[randomKey!]!
        buttonText = randomKey!
        
       

        //populate textArray with the correct answer and 3 random answers that are not the correct answer and are not the same
        answers.append(correctAnswer)
        while answers.count < 4 {
            let randomValue = textArray.randomElement()
            //get the value of the key from the person dictionary
            let randomAnswer = person[randomValue!]!
            if !answers.contains(randomAnswer) {
                answers.append(randomAnswer)
            }
        }
        //shuffle the array
        answers.shuffle()
       
        print(answers)
    }

    
}
