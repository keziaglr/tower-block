//
//  HomeView.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @State private var showLayer1 = false
    @State private var showLayer2 = false
    @State private var showLayer3 = false
    @State private var moveCloud1 = false
    @State private var moveCloud2 = false
    @State private var moveCloud3 = false
    @State private var showLogo = false
    @State var cdm = CoreDataManager()
    @State var mc = MusicController()
    @State var home : Bool = true
    @State var audioPlayer: AVAudioPlayer?
    var body: some View {
        NavigationView {
            ZStack{
                ZStack{
                    if showLayer3{
                        Image("city3")
                            .resizable()
                            .transition(.move(edge: .bottom))
                            .opacity(showLayer3 ? 1.0 : 0.0)
                    }
                    if showLayer2{
                        Image("city2")
                            .resizable()
                            .transition(.move(edge: .bottom))
                            .opacity(showLayer2 ? 1.0 : 0.0)
                    }
                    if showLayer1{
                        Image("city1")
                            .resizable()
                            .transition(.move(edge: .bottom))
                            .opacity(showLayer1 ? 1.0 : 0.0)
                    }
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                    .frame(width: 275, height: 275)
                    .opacity(0.8)
                    .offset(x:moveCloud1 ? 175 : -175, y:-275)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1)
                            .speed(0.05)
                            .repeatForever(autoreverses: true)) {
                                moveCloud1.toggle()
                            }
                    }
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .opacity(0.7)
                        .offset(x:moveCloud2 ? -200 : 200, y:-150)
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1)
                                .speed(0.05)
                                .repeatForever(autoreverses: true)) {
                                    moveCloud2.toggle()
                                }
                        }
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .opacity(0.6)
                        .offset(x:moveCloud3 ? 100 : -100, y: -30)
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1)
                                .speed(0.05)
                                .repeatForever(autoreverses: true)) {
                                    moveCloud3.toggle()
                                }
                        }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background{
                    AppColor.sky
                }
                .onAppear {
                    for i in stride(from: 0, to: 3, by: 0.25) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                            withAnimation(Animation.easeInOut(duration: 2.0)) {
                                switch i {
                                case 0.25:
                                    showLayer1 = true
                                case 0.5:
                                    showLayer2 = true
                                case 0.75:
                                    showLayer3 = true
                                case 1.75:
                                    showLogo = true
                                default:
                                    break
                                }
                            }
                        }
                    }
                    
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
                    }.offset(y:showLogo ? 0 : 100)
                    .opacity(showLogo ? 1.0 : 0.001)
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
