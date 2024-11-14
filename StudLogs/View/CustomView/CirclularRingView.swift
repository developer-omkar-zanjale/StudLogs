//
//  CirclularRingView.swift
//  StudLogs
//
//  Created by admin on 24/02/23.
//

import SwiftUI

struct RingData {
    let data: Int
    let totalData: Int
}

enum SelectedRing {
    case innerRing
    case outerRing
}

struct CirclularRingView: View {
    
    var backgroundColor: Color = Color.clear
    var showShadow: Bool = true
    var twoRingsDistance: CGFloat = 60
    
    var innerRingColors: [Color] = [.red]
    var innerRingBackgroundColor: Color = .gray
    var innerRingStopperColor: [Color] = [.yellow]
    
    var outerRingColors: [Color] = [.blue]
    var outerRingBackgroundColor: Color = .gray
    var outerRingStopperColor: [Color] = [.yellow]
    
    @State var isInnerRingSelected = false
    @State var isOuterRingSelected = false
    var innerRingSelection: Double
    var outerRingSelection: Double
    @State var animation: Animation? = Animation
        .easeIn(duration: 0.8)
            .delay(1)
    @State var animate = false
    
    @State var centralText: String = "Select"
    var centralTextColor: Color = .orange
    
    var innerRingDataTitle: String
    var outerRingDataTitle: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 240, alignment: .center)
                .foregroundColor(backgroundColor)
                .shadow(color: .gray, radius: showShadow ? 5 : 0, x: 0, y: 0)
                .cornerRadius(15)
            VStack(spacing: 25) {
                ZStack {
                    
                    let txt = !isInnerRingSelected && !isOuterRingSelected ? "Select" : "\(centralText)%"
                    //MARK: Center Text
                    Text(txt)
                        .font(.system(.title3, design: .default))
                        .foregroundColor(isInnerRingSelected ? innerRingColors.first : isOuterRingSelected ? outerRingColors.first : centralTextColor)
                        .bold()
                    
                    
                    //MARK: Outer Ring
                    ZStack {
                        Circle()
                            .stroke(outerRingBackgroundColor, lineWidth: 10)
                        Circle()
                            .trim(from: 0, to: animate ? outerRingSelection : 0)
                            .stroke(
                                AngularGradient(colors: outerRingColors, center: .center, startAngle: .zero, endAngle: .degrees(360)),
                                style: StrokeStyle(lineWidth: isOuterRingSelected ? 15 : 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        Circle()
                            .trim(from: outerRingSelection + 0.01, to: animate ? outerRingSelection + 0.012 : 0)
                            .stroke(
                                AngularGradient(colors: outerRingStopperColor, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)),
                                style: StrokeStyle(lineWidth: isOuterRingSelected ? 22 : 19, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                    }
//                    .animation(animation, value: animate)
                    .frame(width: 100 + twoRingsDistance, height: 100 + twoRingsDistance, alignment: .center)
                    .onTapGesture {
                        if isInnerRingSelected {
                            isInnerRingSelected = false
                        }
                        isOuterRingSelected.toggle()
                        setCentralText(forRing: .outerRing)
                    }
                    
                    //MARK: Inner Ring
                    ZStack {
                        Circle()
                            .stroke(innerRingBackgroundColor, lineWidth: 10)
                        
                        Circle()
                            .trim(from: 0, to: animate ? innerRingSelection : 0)
                            .stroke(
                                AngularGradient(colors: innerRingColors, center: .center, startAngle: .degrees(300), endAngle: .degrees(0)),
                                style: StrokeStyle(lineWidth: isInnerRingSelected ? 15 : 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        Circle()
                            .trim(from: innerRingSelection + 0.01, to: animate ? innerRingSelection + 0.012 : 0)
                            .stroke(
                                AngularGradient(colors: innerRingStopperColor, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)),
                                style: StrokeStyle(lineWidth: isInnerRingSelected ? 22 : 19, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                    }
//                    .animation(animation, value: animate)
                    .frame(width: 100, height: 100, alignment: .center)
                    .onTapGesture {
                        if isOuterRingSelected {
                            isOuterRingSelected = false
                        }
                        isInnerRingSelected.toggle()
                        setCentralText(forRing: .innerRing)
                    }
                    
                    
                }
                .animation(animation, value: animate)
                
                
                //MARK: Footer Info
                HStack(spacing: 40) {
                    HStack(spacing: 5) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 15, height: 15)
                            .foregroundColor(innerRingColors.first)
                        
                        Text(innerRingDataTitle)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 5) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 15, height: 15)
                            .foregroundColor(outerRingColors.first)
                        
                        Text(outerRingDataTitle)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onChange(of: innerRingSelection) { _ in
                self.centralText = "Select"
                self.isInnerRingSelected = false
                self.isOuterRingSelected = false
                animate = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    animate = true
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                animate = true
            }
        }
        
    }
    
    
    
    private func setCentralText(forRing selectedRing: SelectedRing) {
        switch selectedRing {
        case .innerRing:
            centralText = String(Int(innerRingSelection * 100))
        case .outerRing:
            centralText = String(Int(outerRingSelection * 100))
        }
    }
}

struct CirclularRingView_Previews: PreviewProvider {
    static var previews: some View {
        CirclularRingView(innerRingSelection: 0.3, outerRingSelection: 0.4, innerRingDataTitle: "Present", outerRingDataTitle: "Absent")
    }
}
