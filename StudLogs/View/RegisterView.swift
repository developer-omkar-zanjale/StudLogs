//
//  RegisterView.swift
//  StudLogs
//
//  Created by admin on 13/02/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State var email: String = ""
    @State var emailBorderColor: Color = .orange
    @State var name: String = ""
    @State var department: String = ""
    @State var age: String = ""
    @State var studentClass: String = ""
    @State var division: String = ""
    @State var nameBorderColor: Color = .orange
    @State var password: String = ""
    @State var passwordBorderColor: Color = .orange
    @State var registerBtnTitle = "Register"
    @State var isHideLoader = true
    @State var isShowAlert = false
    
    let registerVM = RegisterViewModel()
    
    init() {
//        UIScrollView.appearance().bounces = false
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image("welcome")
                .resizable()
                .frame(width: 120, height: 120, alignment: .center)
                .padding()
                .padding(.top)
            ScrollView(showsIndicators: false) {
                ZStack {
                    Rectangle()
                        .cornerRadius(70, corners: [.topLeft, .topRight])
                        .foregroundColor(Color(UIColor.lightGray))
                    Rectangle()
                        .cornerRadius(50, corners: [.topLeft, .topRight])
                        .padding(.top, 90)
                        .foregroundColor(AppColors.middlePanel)
                    VStack {
                        Text("Create New Account")
                            .font(.system(size: 24, weight: .semibold, design: .serif))
                            .padding([.top, .bottom], 20)
                        HStack(alignment: .bottom, spacing: 20) {
                            NavigationLink {
                                
                            } label: {
                                Image("apple-logo")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }
                            
                            NavigationLink {
                                
                            } label: {
                                Image("facebook")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }
                            
                            NavigationLink {
                                
                            } label: {
                                Image("google")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                            }
                        }
                        .padding()
                        
                        CustomTxtField(text: $email, borderColor: $emailBorderColor, placeholder: "Email", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                            .onChange(of: email) { newValue in
                                emailBorderColor = CommenFunctions.isEmailValid(email: newValue) ? .green : .red
                            }
                        CustomTxtField(text: $name, borderColor: $nameBorderColor, placeholder: "Name ", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                            .onChange(of: name) { newValue in
                                self.nameBorderColor = (newValue.isEmpty || newValue.count < 4) ? .red : .green
                            }
                        CustomTxtField(text: $password, borderColor: $passwordBorderColor, placeholder: "Password", placeholderBGColor: AppColors.middlePanel)
                            .padding()
                            .onChange(of: password) { newValue in
                                passwordBorderColor = CommenFunctions.isPasswordValid(password: newValue) ? .green : .red
                            }
                        CustomTxtField(text: $age, borderColor: .constant(.orange), placeholder: "Age", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                        CustomTxtField(text: $department, borderColor: .constant(.orange), placeholder: "Department", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                        CustomTxtField(text: $studentClass, borderColor: .constant(.orange), placeholder: "Class", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                       
                        CustomTxtField(text: $division, borderColor: .constant(.orange), placeholder: "Division", placeholderBGColor: AppColors.middlePanel)
                            .padding([.leading, .trailing, .top])
                        VStack{
                            Button {
                                registerBtnTitle = ""
                                isHideLoader = false
                                if registerVM.checkAllowLogin(userName: email, password: password, name: name) {
                                    registerVM.registerStudent(name: name, email: email, password: password, age: age, studentClass: studentClass, div: division, department: department) { isSuccess in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            isHideLoader = true
                                            registerBtnTitle = "Register"
                                            isShowAlert = !isSuccess
                                            if isSuccess {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                } else {
                                    isHideLoader = true
                                    registerBtnTitle = "Register"
                                    isShowAlert = true
                                }
                            } label: {
                                ZStack {
                                    CustomButtonView(font: .system(size: 24, weight: .semibold, design: .serif), title: $registerBtnTitle)
                                    LoaderView(tintColor: .red, scaleSize: 2.0).hidden(isHideLoader)
                                }
                            }
                            .padding()
                            
                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.black)
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Text("Login here")
                                        .foregroundColor(.green)
                                }
                            }
                            .font(.system(size: 18, weight: .semibold, design: .serif))
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                        }
                     
                        
                        
                    }
                    .padding([.top, .leading, .trailing])
                    .scaledToFit()
                }
            }
            .cornerRadius(50, corners: [.topLeft, .topRight])
            .alert("Warning", isPresented: $isShowAlert) {
                
            } message: {
                Text("\(registerVM.alertMessage)")
            }
        }
        .navigationBarHidden(true)
        .background(AppColors.background)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
