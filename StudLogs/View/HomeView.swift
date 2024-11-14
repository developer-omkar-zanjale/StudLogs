//
//  HomeView.swift
//  StudLogs
//
//  Created by admin on 17/02/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @State var absentData: Double = 0.9
    @State var presentData: Double = 0.6
    @State var currentSelectionForRingGraph = GraphSelectionType.thisMonth.rawValue
    @State var showLoader = false
    @State var isShowAlert = false
    @State var didShowCalenderView = false
    @State var didShowProfileView = false
    @State var menuSelection: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Namespace var currentID
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                //MARK: Top View
                ZStack(alignment: .top) {
                    RoundedCorners(tl: 0, tr: 0, bl: 40, br: 40)
                        .ignoresSafeArea()
                        .frame(height: 230)
                        .foregroundColor(AppColors.topAppearrance)
                    VStack {
                        HStack {
                            Text("Home")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                            
                            Button {
                                didShowCalenderView.toggle()
                            } label: {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .tint(.white)
                                    .padding()
                                
                            }
                            Menu {
                                Button("Profile") {
                                    didShowProfileView = true
                                }
                                Button("Logout") {
                                    CommenFunctions.removeLoggedUserCred()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .tint(.white)
                            }
                        }
                        .padding([.leading, .trailing])
                        ScrollViewReader { value in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    //MARK: Top Dates View
                                    ForEach(Array(homeVM.thisMonthDates.enumerated()), id: \.element) { index, date in
                                        let color = self.homeVM.selectedDateIndex == index ? Color.white : Color(hex: "#D4F1F4")
                                        DateView(color: color, date: date.date ?? "", day: date.day ?? "")
                                            .id(date.day == AppConstants.today ? currentID : nil)
                                            .padding(3)
                                            .onTapGesture {
                                                self.homeVM.selectedDateIndex = index
                                                self.homeVM.fetchLogDataForSelectedIndex()
                                            }
                                    }
                                    
                                }
                            }
                            .padding([.leading, .trailing])
                            .onAppear {
                                value.scrollTo(currentID)
                            }
                        }
                    }
                }
                //
                //MARK: Punch-In/Out Btn
                //
                HStack(spacing: 15) {
                    Button {
                        self.showLoader = true
                        self.homeVM.uploadEntryData { isSuccess in
                            self.showLoader = false
                            self.isShowAlert = !isSuccess
                        }
                    } label: {
                        CustomButtonView(height: 55, color: AppColors.buttons, textColor: AppColors.buttonText, font: .system(size: 20, weight: .medium, design: .serif), title: .constant("Punch-In"))
                    }
                    .disabled((homeVM.selectedDateEntryLog?.isPunchedIn ?? false) ? true : false)
                    Button {
                        self.showLoader = true
                        self.homeVM.uploadEntryData(isForPunchIn: false) { isSuccess in
                            self.showLoader = false
                            self.isShowAlert = !isSuccess
                        }
                    } label: {
                        CustomButtonView(height: 55, color: AppColors.buttons, textColor: AppColors.buttonText, font: .system(size: 20, weight: .medium, design: .serif), title: .constant("Punch-Out"))
                    }
                    .disabled((homeVM.selectedDateEntryLog?.isPunchedOut ?? false) ? true : false)
                }
                .padding([.top, .bottom])
                .padding([.leading, .trailing], 40)
                .padding(.top, -55)
                
                Spacer()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        //MARK: Punch-In/Out Panel
                        ZStack(alignment: .leading) {
                            HStack {
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
                            }
                            .padding([.leading, .trailing])
                        }
                        .background(AppColors.middlePanel, in: RoundedRectangle(cornerRadius: 15))
                        
                        //MARK: Ring-Graph Chart
                        ScrollView {
                            VStack(alignment: .trailing, spacing: 5) {
                                CustomDropDownView(data: GraphSelectionType.allCases, selectedText: $currentSelectionForRingGraph)
                                    .padding([.trailing, .top])
                                CirclularRingView(backgroundColor: AppColors.buttons, innerRingSelection: homeVM.absentGraphData, outerRingSelection: homeVM.presentGraphData, innerRingDataTitle: "Absent", outerRingDataTitle: "Present")
                            }
                            .background(AppColors.buttons)
                            .cornerRadius(25)
                        }
                        .frame(width: 280, height: 290)
                        .padding([.top, .bottom])
                        
                        .onChange(of: currentSelectionForRingGraph) { newValue in
                            homeVM.fetchChartData(forType: currentSelectionForRingGraph)
                        }
   
                    }
                    .padding()
                }
                .refreshable {
                    self.showLoader = true
                    homeVM.getEntryLogs {
                        homeVM.fetchChartData(forType: currentSelectionForRingGraph)
                        self.showLoader = false
                    }
                }
                Spacer()
            }
            if showLoader {
                LoaderView(tintColor: AppColors.primaryText, scaleSize: 2.5)
            }
            
            NavigationLink(destination: CalenderView().environmentObject(homeVM), isActive: $didShowCalenderView, label: {})
            NavigationLink(destination: ProfileView().environmentObject(homeVM), isActive: $didShowProfileView, label: {})
        }
        .navigationBarHidden(true)
        .onAppear {
            self.showLoader = true
            homeVM.getEntryLogs {
                homeVM.fetchChartData(forType: currentSelectionForRingGraph)
                self.showLoader = false
            }
        }
        .alert("Warning", isPresented: $isShowAlert) {
            
        } message: {
            Text("\(homeVM.alertMessage)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
