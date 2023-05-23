//
//  PopupGameOver.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI

struct PopupGameOver: View {
    @State var mc: MusicController
    @State var score = 0
    @Binding var nextPage : Bool
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Game Over")
                    .textCase(.uppercase)
                    .font(.custom(AppFont.regular, size: 36))
                    .foregroundColor(AppColor.navy)
                VStack {
                    Text("Your Score")
                        .font(.custom(AppFont.regular, size: 18))
                    .foregroundColor(AppColor.gray)
                    Text("\(score)")
                        .font(.custom(AppFont.regular, size: 80))
                        .foregroundColor(AppColor.navy)
                }.padding(.vertical, 30)
                
                HStack(spacing: 70){
                    NavigationLink {
                        GameView(mc:mc)
                    } label: {
                        CustomButton2(text: "REPLAY")
                    }

                    Button {
                        withAnimation(
                                Animation.linear(duration: 0.5)
                            ) {
                                nextPage = true
                            }
                    } label: {
                        CustomButton(text: "NEXT")
                    }
                }
            }
            .padding(20)
            .frame(width: 350, height: 350)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(AppColor.white)
                    .shadow(radius: 10)
            )
        }
    }
}

struct Popup: View{
    @State var mc: MusicController
    @State var score = 0
    @State var nextPage = false
    var body: some View {
        ZStack{
            if !nextPage{
                PopupGameOver(mc:mc, score: score, nextPage: $nextPage)
            }else{
                PopupSubmit(score: score,mc: mc)
            }
        }
    }
}

struct PopupSubmit: View {
    @State var text: String = ""
    @State var score = 0
    @State var mc: MusicController
    @State var cdm = CoreDataManager()
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("New Score!")
                    .textCase(.uppercase)
                    .font(.custom(AppFont.regular, size: 36))
                    .foregroundColor(AppColor.navy)
                Text("\(score)")
                    .font(.custom(AppFont.regular, size: 100))
                    .foregroundColor(AppColor.navy)
                    .padding(.vertical, 2)
                Text("Your Name")
                    .font(.custom(AppFont.regular, size: 18))
                .foregroundColor(AppColor.gray)
                TextField("", text: $text)
                    .font(.custom(AppFont.regular, size: 21))
                    .foregroundColor(AppColor.navy)
                    .frame(width: 200, height: 40)
                    .padding(.horizontal,10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.navy, lineWidth: 3)
                    )
                    .padding(.bottom, 30)
                NavigationLink {
                    HomeView(mc: mc)
                } label: {
                    CustomButton(text: "SUBMIT")
                }
                .disabled(text == "")
                .opacity(text == "" ? 0.5 : 1.0)
                .simultaneousGesture(TapGesture().onEnded {
                    if text != ""{
                        cdm.addData(name: text, score: score)
                    }
                })
            }
            .padding(20)
            .frame(width: 350, height: 350)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(AppColor.white)
                    .shadow(radius: 10)
            )
        }
    }
}

struct LeaderboardPopup: View {
    @State var cdm = CoreDataManager()
    var body: some View {
        ZStack{
            
            VStack {
                Text("SCOREBOARD")
                    .textCase(.uppercase)
                    .font(.custom(AppFont.regular, size: 36))
                    .foregroundColor(AppColor.navy)
                VStack{
                    ForEach(cdm.savedEntities.prefix(5), id: \.self) { entity in
                        HStack {
                            Text("\((cdm.savedEntities.firstIndex(of: entity) ?? 0 ) + 1). \(entity.name ?? "kezia")")
                                .font(.custom(AppFont.regular, size: 21))
                            .foregroundColor(AppColor.navy)
                            Spacer()
                            Text("\(entity.score)")
                                .font(.custom(AppFont.regular, size: 28))
                                .foregroundColor(AppColor.navy)
                        }
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(AppColor.navy)
                            .padding(.bottom,15)
                    }
                }
                .padding(20)
                .frame(width: 350, height: 400)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(AppColor.white)
                        .shadow(radius: 3)
            )
            }
        }
    }
}

struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardPopup()
    }
}
