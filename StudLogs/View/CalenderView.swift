//
//  CalenderView.swift
//  StudLogs
//
//  Created by admin on 29/05/23.
//

import SwiftUI

struct CalenderView: View {
    @State var selectedDate: Date = Date()
    @State var showLoader = false
    @State var isShowAlert = false
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            if showLoader {
                LoaderView(tintColor: AppColors.primaryText, scaleSize: 2.5)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    //
                    //MARK: Date Picker
                    //
                    DatePicker("Select", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .onChange(of: selectedDate) { newValue in
                            self.homeVM.fetchLogData(forDate: newValue)
                        }
                    //
                    //MARK: Punch-In/Out Btn
                    //
                    HStack(spacing: 15) {
                        Button {
                            if selectedDate >= Date().startOfMonth() {
                                self.showLoader = true
                                self.homeVM.uploadEntryData(forDate: selectedDate) { isSuccess in
                                    self.showLoader = false
                                    self.isShowAlert = !isSuccess
                                }
                            } else {
                                homeVM.alertMessage = AlertMessages.cannotPunchInForPastDate
                                isShowAlert = true
                            }
                        } label: {
                            CustomButtonView(height: 55, color: AppColors.buttons, textColor: AppColors.buttonText, font: .system(size: 20, weight: .medium, design: .serif), title: .constant("Punch-In"))
                        }
                        .disabled((homeVM.selectedDateEntryLog?.isPunchedIn ?? false) ? true : false)
                        Button {
                            if selectedDate >= Date().startOfMonth() {
                                self.showLoader = true
                                self.homeVM.uploadEntryData(forDate: selectedDate, isForPunchIn: false) { isSuccess in
                                    self.showLoader = false
                                    self.isShowAlert = !isSuccess
                                }
                            } else {
                                homeVM.alertMessage = AlertMessages.cannotPunchOutForPastDate
                                isShowAlert = true
                            }
                        } label: {
                            CustomButtonView(height: 55, color: AppColors.buttons, textColor: AppColors.buttonText, font: .system(size: 20, weight: .medium, design: .serif), title: .constant("Punch-Out"))
                        }
                        .disabled((homeVM.selectedDateEntryLog?.isPunchedOut ?? false) ? true : false)
                    }
                    .padding()
                    //
                    //MARK: In/Out Panel
                    //
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Text("Punch In")
                                .font(.system(size: 19, weight: .semibold, design: .serif))
                            if let selectedLogInDetail = homeVM.selectedDateEntryLog?.inDetails {
                                Text("\(selectedLogInDetail.isEmpty ? AppConstants.na : selectedLogInDetail)")
                            } else {
                                Text(AppConstants.na)
                            }
                        }
                        .foregroundColor(AppColors.primaryText)
                        .padding()
                        Spacer()
                        VStack(spacing: 10) {
                            Text("Punch Out")
                                .font(.system(size: 19, weight: .semibold, design: .serif))
                            if let selectedLogOutDetail = homeVM.selectedDateEntryLog?.outDetails {
                                Text("\(selectedLogOutDetail.isEmpty ? AppConstants.na : selectedLogOutDetail)")
                            } else {
                                Text(AppConstants.na)
                            }
                        }
                        .foregroundColor(AppColors.primaryText)
                        .padding()
                        .onChange(of: homeVM.studData) { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.homeVM.fetchLogData(forDate: selectedDate)
                            }
                        }
                        Spacer()
                    }
                    .background(AppColors.middlePanel, in: RoundedRectangle(cornerRadius: 15))
                }
                .padding([.leading, .trailing])
                .alert("Warning", isPresented: $isShowAlert) {} message: {
                    Text("\(homeVM.alertMessage)")
                }
            }
            .padding(.top, 100)
        }
        .ignoresSafeArea()
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
            .environmentObject(HomeViewModel())
    }
}
