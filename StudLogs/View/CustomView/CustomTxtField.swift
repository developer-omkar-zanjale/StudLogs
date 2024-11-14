//
//  CustomTxtField.swift
//  StudLogs
//
//  Created by admin on 10/02/23.
//

import SwiftUI

struct CustomTxtField: View {
    @Binding var text: String
    @Binding var borderColor: Color
    @State var isShowTopHolder = false
    @State var isShowPassword = false
    
    var placeholder: String = "Placeholder"
    var placeholderColor: Color = .orange
    var cornerRadius: CGFloat = 4
    var borderWidth: CGFloat = 2
    var isPassWordField: Bool = false
    var placeholderBGColor: Color = .white
    
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(height: 60, alignment: .center)
                    .foregroundColor(.clear)
                if isShowTopHolder {
                    ZStack {
                        Rectangle()
                            .frame(width: CGFloat(placeholder.count * 11) , height: 60, alignment: .topLeading)
                            .padding(.bottom)
                            .border(width: 20, edges: [.top], color: placeholderBGColor)
                            .padding(.leading, 20)
                            .foregroundColor(.clear)
                        Text(placeholder)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .padding(.leading)
                            .frame(height: 60, alignment: .topLeading)
                            .foregroundColor(placeholderColor)
                            .padding(.bottom, 22)
                            
                    }
                } else {
                    Text(placeholder)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .padding(.leading)
                        .foregroundColor(placeholderColor)
                }
            }
            
            let bindingText = Binding<String>(get: {
                self.text
            }, set: {
                self.text = $0
                self.isShowTopHolder = !$0.isEmpty
            })
            Group {
                HStack {
                    if isShowPassword {
                        TextField("", text: bindingText)
                            .frame(height: 62, alignment: .center)
                            .textInputAutocapitalization(.never)
                            .padding(.leading)
                    } else {
                        SecureField("", text: bindingText)
                            .frame(height: 62, alignment: .center)
                            .textInputAutocapitalization(.never)
                            .padding(.leading)
                    }
                    Button {
                        self.isShowPassword.toggle()
                    } label: {
                        Image(systemName: self.isShowPassword ? "eye" : "eye.slash")
                            .accentColor(.gray)
                    }
                    .padding(.trailing)
                }
                .opacity(isPassWordField ? 1 : 0)
                
                TextField("", text: bindingText)
                    .textInputAutocapitalization(.never)
                    .frame(height: 62, alignment: .center)
                    .padding(.leading)
                    .opacity(isPassWordField ? 0 : 1)
            }
        }
    }
}


struct CustomTxtField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTxtField(text: .constant(""), borderColor: .constant(.orange))
            .previewInterfaceOrientation(.portrait)
    }
}
