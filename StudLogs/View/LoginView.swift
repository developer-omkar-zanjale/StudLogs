//
//  LoginView.swift
//  StudLogs
//
//  Created by admin on 10/02/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var userName: String = ""
    @State var userNameBorderColor: Color = .orange
    @State var password: String = ""
    @State var passwordBorderColor: Color = .orange
    @State var isAllowLogin = false
    @State var isShowAlert = false
    @State var topImage = "welcome"
    @State var isHideLoader = true
    @State var loginBtnTitle = "Login"
    
    let loginVM = LoginViewModel()
    
    var body: some View {
        
        VStack {
            Image(topImage)
                .resizable()
                .frame(width: 120, height: 120, alignment: .center)
                .padding()
            
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .cornerRadius(70, corners: [.topLeft, .topRight])
                        .foregroundColor(Color(UIColor.lightGray))
                    Rectangle()
                        .cornerRadius(50, corners: [.topLeft, .topRight])
                        .padding(.top, 90)
                        .foregroundColor(AppColors.middlePanel)
                    VStack {
                        Text("Login to your account")
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
                        .disabled(true)
                        .padding()
                        
                        CustomTxtField(text: $userName, borderColor: $userNameBorderColor, placeholder: "User Name", placeholderBGColor: AppColors.middlePanel)
                            .onChange(of: userName) { newValue in
                                if CommenFunctions.isEmailValid(email: newValue) {
                                    userNameBorderColor = .green
                                    topImage = "good"
                                } else {
                                    userNameBorderColor = .red
                                    topImage = "laughter"
                                }
                            }
                            .padding([.leading, .trailing, .top])
                        CustomTxtField(text: $password, borderColor: $passwordBorderColor, placeholder: "Password", isPassWordField: true, placeholderBGColor: AppColors.middlePanel)
                            .padding()
                            .onChange(of: password) { newValue in
                                if CommenFunctions.isPasswordValid(password: newValue) {
                                    passwordBorderColor = .green
                                    topImage = "good"
                                } else {
                                    passwordBorderColor = .red
                                    topImage = "laughter"
                                }
                            }
                        
                        Button {
                            topImage = "lets-go"
                            isHideLoader = false
                            loginBtnTitle =  ""

                            if loginVM.checkAllowLogin(userName: userName, password: password) {
                                self.loginVM.isUserAvailable(email: userName, password: password) { result in
                                    isHideLoader = true
                                    loginBtnTitle =  "Login"
                                    topImage = result ? "good-bye" : "shocked"
                                    isShowAlert = !result
                                    isAllowLogin = result
                                }
                            } else {
                                isHideLoader = true
                                loginBtnTitle =  "Login"
                                isShowAlert = true
                            }
                            
                        } label: {
                            ZStack {
                                CustomButtonView(title: $loginBtnTitle)
                                LoaderView(tintColor: .red, scaleSize: 2.0).hidden(isHideLoader)
                                
                            }
                        }
                        .padding()
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.black)
                            NavigationLink {
                                RegisterView()
                            } label: {
                                Text("Register here")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.bottom)
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .padding(.top, 40)
                    }
                    .padding()
                }
                .scaledToFit()
            }
            .cornerRadius(70, corners: [.topLeft, .topRight])
            .alert("Warning", isPresented: $isShowAlert) {
                
            } message: {
                Text("\(loginVM.alertMessage)")
            }
            NavigationLink(destination: HomeView(), isActive: $isAllowLogin){}
        }
        .onAppear {
            isHideLoader = false
            loginBtnTitle = ""
            loginVM.checkAutoLogin { isSuccess in
                isHideLoader = true
                loginBtnTitle = "Login"
                if let isSuccess = isSuccess {
                    isShowAlert = !isSuccess
                    isAllowLogin = isSuccess
                }
            }
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .previewInterfaceOrientation(.portrait)
            LoginView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
