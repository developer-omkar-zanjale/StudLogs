//
//  CustomDropDownView.swift
//  StudLogs
//
//  Created by admin on 27/02/23.
//

import SwiftUI

struct CustomDropDownView: View {
    
    var data: [String]
    
    @Binding var selectedText: String
    
    var body: some View {
        ZStack {
                Rectangle()
                .border(AppColors.buttonText, width: 2)
                    .foregroundColor(.clear)
                
            Picker("Select", selection: $selectedText) {
                ForEach(data, id: \.self) { ele in
                    Text(ele)
                }
            }
            .pickerStyle(.menu)
        }
        .frame(width: 140, height: 30, alignment: .center)
    }
}

struct CustomDropDownView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropDownView(data: ["1", "2", "3", "4"], selectedText: .constant("Select"))
    }
}
