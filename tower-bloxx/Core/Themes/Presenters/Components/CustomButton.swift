//
//  CustomButton.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI

struct CustomButton: View {
    @State var text: String
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .padding(.vertical,10)
                .padding(.horizontal, 20)
                .foregroundColor(AppColor.white)
                .fontWeight(.bold)
                .font(.custom(AppFont.regular, size: 18))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.navy)
                        .frame(width: 140)
                )
        }
    }
}

struct CustomButton2: View {
    @State var text: String
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text)
                .padding(.vertical,10)
                .padding(.horizontal, 20)
                .foregroundColor(AppColor.navy)
                .fontWeight(.bold)
                .font(.custom(AppFont.regular, size: 18))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColor.navy, lineWidth: 3)
                        .frame(width: 140)
                )
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton2(text:"hi")
    }
}
