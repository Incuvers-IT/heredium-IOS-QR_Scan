//
//  LogView.swift
//  app
//
//  Created by Muune on 2023/02/28.
//

import SwiftUI
import CoreData

struct LogView: View {
    var body: some View {
        ZStack{
            Color.white
            ListView()
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}

extension LogInfo {
  static var limitFetchRequest: NSFetchRequest<LogInfo> {
    let request: NSFetchRequest<LogInfo> = LogInfo.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \LogInfo.sortId, ascending: false )]
    request.fetchLimit = 200

    return request
  }
}


struct ListView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @FetchRequest(fetchRequest: LogInfo.limitFetchRequest)
    
    var logs: FetchedResults<LogInfo>
    
    @State private var scrollViewContentSize: CGSize = .zero
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.bottom)
            VStack(spacing: 0){
                VStack(spacing: 0){
                    Text("QR 로그")
                        .font(Font.custom(Constants.fontBold, size:28))
                        .lineSpacing(5)
                        .foregroundColor(Color.black_11)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    TableView(rows: logs)
                        .padding(.top, 28)
                }
                .padding([.leading, .trailing], 28)
                .padding(.top, 32)
                
                
                Spacer()
                
                Divider().background(Color("gray_bebebe"))
                
                Button(action:{
                    self.mode.wrappedValue.dismiss()
                }){
                    Text("이전")
                        .font(Font.custom(Constants.fontBold, size:14))
                        .foregroundColor(Color("primary_1"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 44)
                        .border(Color("primary_1"))
                        .padding([.leading, .trailing], 28)
                        .padding([.top, .bottom], 14)
                }
            }
        }
    }
}


struct TableView: View {
    struct Table {
        let labelFontSize: CGFloat
        let valueFontSize: CGFloat
        let labelColor: Color
        let valueColor: Color
        let rows: FetchedResults<LogInfo>

        init(labelFontSize: CGFloat = 14,
             valueFontSize: CGFloat = 14,
             labelColor: Color = .primary,
             valueColor: Color = .secondary,
             rows: FetchedResults<LogInfo>
        ) {
            self.labelFontSize = labelFontSize
            self.valueFontSize = valueFontSize
            self.labelColor = labelColor
            self.valueColor = valueColor
            self.rows = rows
        }

        func labelWidth(row: LogInfo, idx: Int) -> CGFloat {
            let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: valueFontSize)]
            var size:CGSize = CGSize(width: 0, height: 0)
            if(idx == 1){
                size = row.time!.size(withAttributes: fontAttributes)
            }else if(idx == 2){
                size = row.name!.size(withAttributes: fontAttributes)
            }else if(idx == 3){
                size = row.name!.size(withAttributes: fontAttributes)
            }
            return size.width
        }
    }

    private let table: Table
    private let column1Width: CGFloat
    private let column2Width: CGFloat
    private let column3Width: CGFloat
    private let column4Width: CGFloat
    private let column5Width: CGFloat
    private let column6Width: CGFloat

    init(table: Table) {
        self.table = table
        self.column1Width = 60
        self.column2Width = 60
        self.column3Width = 80
        self.column5Width = 70
        self.column6Width = 180        
        self.column4Width = UIScreen.screenWidth - self.column1Width - self.column2Width - self.column3Width - self.column5Width - self.column6Width - 28 - 28
        
        //self.column1Width = table.rows.map({table.labelWidth(row:$0, idx:1)}).max() ?? 100
    }

    init(rows: FetchedResults<LogInfo>) {
        self.init(table: Table(rows: rows))
    }

    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center, spacing: 0) {
                Text("No")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(width: column1Width, alignment: .center)
                    .frame(height: 44)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack(spacing: 0){Divider().offset(x: 0, y: 22)})
                    .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column1Width*0.5), y: 0)})
                Text("시간")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(width: column2Width, alignment: .center)
                    .frame(height: 44)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack{Divider().offset(x: 0, y: 22)})
                    .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column2Width*0.5), y: 0)})
                Text("이름")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(width: column3Width, alignment: .center)
                    .frame(height: 44)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack{Divider().offset(x: 0, y: 22)})
                    .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column3Width*0.5), y: 0)})
                Text("이메일")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(height: 44)
                    .padding([.leading, .trailing], 10)
                    .frame(width: column4Width, alignment: .center)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack{Divider().offset(x: 0, y: 22)})
                    .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column4Width*0.5), y: 0)})
                Text("인원")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(height: 44)
                    .padding([.leading, .trailing], 10)
                    .frame(width: column5Width, alignment: .center)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack{Divider().offset(x: 0, y: 22)})
                    .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column5Width*0.5), y: 0)})
                Text("입장권 아이디")
                    .font(Font.custom(Constants.fontBold, size:14))
                    .foregroundColor(Color.black_11)
                    .frame(height: 44)
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .overlay(VStack{Divider().background(Color("black_11")).offset(x: 0, y: -22)})
                    .overlay(VStack{Divider().offset(x: 0, y: 22)})
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(table.rows.enumerated()), id: \.offset) { index, row in
                        HStack(alignment: .center, spacing: 0) {
                            Text("\(table.rows.count-index)")
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(width: column1Width, alignment: .center)
                                .frame(height: 44)
                                .overlay(VStack(spacing: 0){Divider().offset(x: 0, y: 22)}.frame(maxHeight: 44))
                                .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column1Width*0.5), y: 0)})
                            Text(row.time ?? "")
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(width: column2Width, alignment: .center)
                                .frame(height: 44)
                                .overlay(VStack{Divider().offset(x: 0, y: 22)})
                                .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column2Width*0.5), y: 0)})
                            Text(row.name ?? "")
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(width: column3Width, alignment: .center)
                                .frame(height: 44)
                                .overlay(VStack{Divider().offset(x: 0, y: 22)})
                                .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column3Width*0.5), y: 0)})
                            Text((row.email ?? "").count > 30 ? (row.email ?? "").prefix(27) + "..." : (row.email ?? ""))
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(height: 44)
                                .padding([.leading, .trailing], 10)
                                .frame(width: column4Width, alignment: .leading)
                                .overlay(VStack{Divider().offset(x: 0, y: 22)})
                                .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column4Width*0.5), y: 0)})
                            Text("\(row.person) 명")
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(height: 44)
                                .padding([.leading, .trailing], 10)
                                .frame(width: column5Width, alignment: .trailing)
                                .overlay(VStack{Divider().offset(x: 0, y: 22)})
                                .overlay(HStack{Divider().background(Color("black_11")).offset(x: (column5Width*0.5), y: 0)})
                            Text(row.uuid ?? "")
                                .font(Font.custom(Constants.fontMedium, size:14))
                                .foregroundColor(Color.black_11)
                                .frame(height: 44)
                                .padding([.leading, .trailing], 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(VStack{Divider().offset(x: 0, y: 22)})
                            Spacer()
                        }
                    
                    }
                    
                    
                    
                }
            }
        }
        
    }
}


