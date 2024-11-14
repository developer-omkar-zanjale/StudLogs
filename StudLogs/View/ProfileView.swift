//
//  ProfileView.swift
//  StudLogs
//
//  Created by admin on 30/05/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var showLoader = false
    @State var isShowAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                //
                //MARK: Top view
                //
                ZStack {
                    RoundedCorners(bl: 70, br: 70)
                        .foregroundColor(AppColors.topAppearrance)
                        .frame(height: 300)
                    VStack {
                        HStack(alignment: .top) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                        .font(.system(size: 18, weight: .medium, design: .serif))
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                        Text("\(homeVM.loggedStudent?.name ?? "No name")")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 35)
                }
                //
                //MARK: Profile Data
                //
                
                    List {
                        Section {
                            ListRow(title: "Age", value: homeVM.loggedStudent?.ageInString)
                            ListRow(title: "Gender", value: homeVM.loggedStudent?.gender)
                        }
                        Section {
                            ListRow(title: "Department", value: homeVM.loggedStudent?.department)
                            ListRow(title: "Class", value: homeVM.loggedStudent?.studentClass)
                            ListRow(title: "Division", value: homeVM.loggedStudent?.div)
                        }
                        Section {
                            ListRow(title: "Email", value: homeVM.loggedStudent?.userName)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .modifier(HideListBackgroundModifier())
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .refreshable {
                        self.showLoader = true
                        self.homeVM.getCurrentUserData { isSuccess in
                            self.showLoader = false
                            self.isShowAlert = !isSuccess
                        }
                    }
                    .alert("Warning", isPresented: $isShowAlert){} message: {
                        Text("\(homeVM.alertMessage)")
                    }
                
            }
            .ignoresSafeArea()
            .background(AppColors.background)
            if showLoader {
                LoaderView(tintColor: AppColors.primaryText, scaleSize: 2.5)
            }
        }
        .onAppear {
            self.showLoader = true
            homeVM.getCurrentUserData { isSuccess in
                self.showLoader = false
                self.isShowAlert = !isSuccess
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(HomeViewModel())
    }
}


struct ListRow: View {
    var title: String
    var value: String?
    var body: some View {
        HStack {
            Text("\(title)")
            Spacer()
            Text("\(value ?? "Not-Set")")
        }
    }
}

struct HideListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
                .background(Color.clear)
        }
    }
}
