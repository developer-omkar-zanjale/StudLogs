//
//  DateView.swift
//  StudLogs
//
//  Created by admin on 23/02/23.
//

import SwiftUI

struct DateView: View {
    
    var color = Color(hex: "#038aff")
    var date: String
    var day: String
    
    var body: some View {
        ZStack {
            
            RoundedCorners(tl: 15, tr: 15, bl: 15, br: 15)
                .frame(width: 70, height: 70)
                .foregroundColor(color == .white ? .white : color.opacity(0.1))
            RoundedRectangle(cornerRadius: 15)
                .stroke(color.opacity(0.2), lineWidth: 2)
                .frame(width: 70, height: 70)
            VStack(spacing: 3) {
                Text(date)
                    .font(.title2)
                    .bold()
                    .foregroundColor(color == .white ? Color(hex: "#038aff") : .white)
                
                Text(day)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(color == .white ? .black : .white)
            }
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(date: "07", day: "Tue")
    }
}
