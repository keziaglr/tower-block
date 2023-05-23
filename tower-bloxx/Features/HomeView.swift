//
//  HomeView.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @State var cdm = CoreDataManager()
    @State var mc = MusicController()
    @State var home : Bool = true
    @State var audioPlayer: AVAudioPlayer?
    var body: some View {
        NavigationView {
            ZStack{
                ZStack{
                    Image("city3")
                        .resizable()
                    Image("city2")
                        .resizable()
                    Image("city1")
                        .resizable()
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                    .frame(width: 275, height: 275)
                    .offset(x: -100)
                    .opacity(0.8)
                    .offset(x:-75, y:-275)
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .opacity(0.7)
                        .offset(x:100, y:-150)
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .opacity(0.6)
                        .offset(x:-75, y: -30)
                }.background{
                    AppColor.sky
                }
                if home {
                    VStack{
                        Text("Tower Block")
                            .font(.custom(AppFont.regular, size: 45))
                            .foregroundColor(AppColor.navy)
                            .textCase(.uppercase)
                        NavigationLink(destination: {
                            GameView(mc: mc)
                        }, label: {
                            CustomButton(text: "START GAME")
                        })
                        
                        Button(action: {
                            withAnimation(
                                    Animation.linear(duration: 0.5)
                                ) {
                                    home.toggle()
                                }
                        }, label: {
                            CustomButton(text: "SCOREBOARD")
                        })
                    }
                }else{
                    VStack {
                        LeaderboardPopup()
                        Button(action: {
                            withAnimation(
                                    Animation.linear(duration: 0.5)
                                ) {
                                    home.toggle()
                                }
                        }, label: {
                            CustomButton(text: "OK")
                        })
                    }
                    
                    
                }
            }
            .ignoresSafeArea()
            .onAppear{
                mc.playMusic()
            }
        }.navigationBarBackButtonHidden(true)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
