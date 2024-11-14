//
//  CustomButtonView.swift
//  StudLogs
//
//  Created by admin on 10/02/23.
//

import SwiftUI

struct CustomButtonView: View {
    var height: CGFloat = 60
    var color: Color = .blue
    var cornerRadius: CGFloat = 60
    var textColor: Color = .white
    var font: Font = .system(size: 30, weight: .semibold, design: .default)
    
    @Binding var title: String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: height, alignment: .center)
                .cornerRadius(cornerRadius)
                .foregroundColor(color)
            Text(title)
                .font(font)
                .frame(height: height, alignment: .center)
                .foregroundColor(textColor)
                .padding([.leading, .trailing])
        }
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonView(title: .constant("Title"))
    }
}
