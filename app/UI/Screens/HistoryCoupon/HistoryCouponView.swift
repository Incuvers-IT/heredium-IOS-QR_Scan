//
//  HistoryCoupon.swift
//  app
//
//  Created by Quang Nguyễn on 17/10/24.
//

import SwiftUI

struct HistoryCouponView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @ObservedObject var viewModel: HistoryCouponViewModel = HistoryCouponViewModel()

    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("QR 로그")
                        .font(Font.custom(Constants.fontBold, size: 28))
                        .foregroundColor(Color.black_11)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)
                        .padding([.leading, .trailing, .bottom], 28)

                    
                    List {
                        ForEach(viewModel.items) { item in
                            
                            VStack {
                                HStack {
                                    Text("Coupon Name: ")
                                        .font(Font.custom(Constants.fontBold, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Text(item.couponName)
                                        .font(Font.custom(Constants.fontMedium, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Coupon Type: ")
                                        .font(Font.custom(Constants.fontBold, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Text(item.couponType)
                                        .font(Font.custom(Constants.fontMedium, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Discount: ")
                                        .font(Font.custom(Constants.fontBold, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Text("\(item.discountPercent)%")
                                        .font(Font.custom(Constants.fontMedium, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Expiration date: ")
                                        .font(Font.custom(Constants.fontBold, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Text(item.expirationDate)
                                        .font(Font.custom(Constants.fontMedium, size: 14))
                                        .foregroundStyle(Color.black_11)
                                    
                                    Spacer()
                                }

                            }
                            .listRowBackground(Color(.white))
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 16)
                    
                    Button(action: {
                        mode.wrappedValue.dismiss()
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
}

struct HistoryCouponView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCouponView()
    }
}
