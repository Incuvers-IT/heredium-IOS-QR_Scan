//
//  SettingView.swift
//  app
//
//  Created by Muune on 2023/02/28.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel : MainViewModel
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                Text("QR 체크 설정")
                    .font(Font.custom(Constants.fontBold, size:28))
                    .lineSpacing(5)
                    .foregroundColor(Color.black_11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("QR 체크를 진행할 항목을 선택해 주세요.")
                    .font(Font.custom(Constants.fontMedium, size:16))
                    .foregroundColor(Color.black_11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                Divider().background(Color.black_11).padding(.top, 32)
                
                HStack(alignment:.top, spacing: 0){
                    Text("전시")
                        .font(Font.custom(Constants.fontBold, size:28))
                        .foregroundColor(Color.black_11)
                        .frame(width: 132, alignment: .leading)
                    
                    VStack(spacing: 16){
                        ForEach(0 ..< viewModel.exhibitionList.count, id: \.self){ i in
                            CheckItem(
                                title: viewModel.exhibitionList[i].title,
                                isCheck: viewModel.allowList.filter{$0.id == viewModel.exhibitionList[i].id && $0.kind == viewModel.exhibitionList[i].kind}.count != 0){ isCheck in
                                    viewModel.allowListChange(project: viewModel.exhibitionList[i], isCheck: isCheck)
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(.top, 10)
                }.padding(.top, 40)
                
                Divider().background(Color.black_11).padding(.top, 32)
                
                HStack(alignment:.top, spacing: 0){
                    Text("프로그램")
                        .font(Font.custom(Constants.fontBold, size:28))
                        .foregroundColor(Color.black_11)
                        .frame(width: 132, alignment: .leading)
                    
                    VStack(spacing: 16){
                        ForEach(0 ..< viewModel.programList.count, id: \.self){ i in
                            CheckItem(
                                title: viewModel.programList[i].title,
                                isCheck: viewModel.allowList.filter{$0.id == viewModel.programList[i].id && $0.kind == viewModel.programList[i].kind}.count != 0){ isCheck in
                                    viewModel.allowListChange(project: viewModel.programList[i], isCheck: isCheck)
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(.top, 10)
                }.padding(.top, 40)
                
                Divider().background(Color.black_11).padding(.top, 32)
                
                HStack(alignment:.top, spacing: 0){
                    Text("커피")
                        .font(Font.custom(Constants.fontBold, size:28))
                        .foregroundColor(Color.black_11)
                        .frame(width: 132, alignment: .leading)
                    
                    VStack(spacing: 16){
                        ForEach(0 ..< viewModel.coffeeList.count, id: \.self){ i in
                            CheckItem(
                                title: viewModel.coffeeList[i].title,
                                isCheck: viewModel.allowList.filter{$0.id == viewModel.coffeeList[i].id && $0.kind == viewModel.coffeeList[i].kind}.count != 0){ isCheck in
                                    viewModel.allowListChange(project: viewModel.coffeeList[i], isCheck: isCheck)
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(.top, 10)
                }.padding(.top, 40)
            }
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 32)
            
            
            Spacer()
            
            Divider().background(Color("gray_bebebe"))
            
            HStack(spacing: 20){
                
                Button(action: {
                    viewModel.setCheckAllInit()
                    viewModel.settingListInit()
                    viewModel.getProjects()
                }){
                    Text("초기화")
                        .font(Font.custom(Constants.fontBold, size:14))
                        .foregroundColor(Color("primary_1"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 44)
                        .border(Color("primary_1"))
                }
               
                
                DelayedNavigationLink(destination: ScanQRView().navigationBarHidden(true)){
                    Text("완료")
                        .font(Font.custom(Constants.fontBold, size:14))
                        .foregroundColor(Color("white"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 44)
                        .background(Color("primary_1"))
                }.delayed(by: 1).simultaneousGesture(TapGesture().onEnded{
                    viewModel.toastEvent.send("설정이 저장되었습니다.")
                })
            }
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 14)
        }.onAppear{
            viewModel.log(value:"api 로드 start")
            viewModel.settingListInit()
            viewModel.getProjects()
        }
    }
}



struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct CheckItem: View{
    let title: String
    @State var isCheck:Bool
    let callback: (Bool) -> Void
    //@State private var isChecked = false
    
    var body: some View {
        HStack(spacing: 0){
            Toggle(isOn: $isCheck) {
                  Text(title)
                    .font(Font.custom(Constants.fontMedium, size:14))
                    .lineSpacing(5)
                    .foregroundColor(Color.black_11)
                    .padding(.leading, 8)
              }
            .toggleStyle(.checkmark)
            .onChange(of: isCheck) { _isOn in
                callback(_isOn)
            }
            Spacer()
        }.frame(maxWidth: .infinity)
    }
}


struct CheckboxToggleStyle: ToggleStyle {
   func makeBody(configuration: Configuration) -> some View {
       HStack() {
           RoundedRectangle(cornerRadius: 0.0)
               .strokeBorder(Color("gray_bebebe"), lineWidth: 1)
               .background(configuration.isOn ? Color("primary_1"): Color("white"))
               .frame(width: 18, height: 18)
               .cornerRadius(0.0)
               .overlay (
                    configuration.isOn ?
                        Image("check")
                        .foregroundColor(Color("white")) : nil
               )
               .onTapGesture {
                   withAnimation(.spring()) {
                       configuration.isOn.toggle()
                   }
               }
           
           configuration.label
           
       }
   }
}


extension ToggleStyle where Self == CheckboxToggleStyle {
   static var checkmark: CheckboxToggleStyle {CheckboxToggleStyle() }
}
