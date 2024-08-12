//
//  PopupView.swift
//  Jappame
//
//  Created by fausto.dassenno on 08/08/24.
//

import SwiftUI

struct PopupView: View {
    
    let config : SheetManager.Config
    
    @State var serieToRender = [""]
    @State var shouldRender = true
    
    var didClose: () -> Void
    
    var body: some View {
        HStack {
            if(self.shouldRender) {
                ForEach(config.series, id: \.self) { item in
                    VStack {
                        Text(item)
                            .foregroundColor(.green)
                            .font(.system(size: 30))
                        Text(hiraganaToRomaji[item] ?? "-")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .padding(.leading, 5)
        .multilineTextAlignment(.center)
        .background(background)
        .overlay(alignment: .topTrailing) {
            close
        }
        .onAppear {
        //    withAnimation {
        //        self.serieToRender = []
        //        let quale = Int(config.series.id)!
        //        self.serieToRender = chars[quale]!
        //        self.shouldRender = true
        //    }
            print(config)
        }
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    PopupView(config: .init(series: ["あ"] )){}
        .background(.blue)
        .previewLayout(.sizeThatFits)
        .padding()
}

private extension PopupView {
    
    var background: some View {
        RoundedCorners(color: .white, tl:30, tr: 30, bl:0, br:0)
            .shadow(color: .black.opacity(0.2), radius: 3)
    }
    
}


private extension PopupView {
    
    var tile: some View {
        
        Text("2")

    }
    
    var close: some View {
        Button {
            didClose()
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.circle.fill)
                .font(
                    .system(size: 30, weight: .bold, design: .rounded)
            )
                .foregroundStyle(.gray.opacity(0.4))
                .padding(8)
            
        }
    }
    
    var icon: some View {
        Image(systemName: "info")
            .symbolVariant(.circle.fill)
            .font(
                .system(size: 50,
                        weight: .bold,
                        design: .rounded)
        )
            .foregroundStyle(.blue)
    }
    
    var title: some View {
        Text(config.series[0])
            .padding()
    }
    
    var content: some View {
        Text("Lorem ipsum Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum")
            .font(.callout)
            .foregroundColor(.black.opacity(0.8))
    }
    
    
}

//MARK: https://stackoverflow.com/questions/56760335/how-to-round-specific-corners-of-a-view

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
