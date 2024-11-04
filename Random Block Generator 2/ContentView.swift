//
//  ContentView.swift
//  Random Block Generator 2
//
//  Created by Alex Moulinneuf on 16/05/2024.
//

import SwiftUI

import Combine

class Users: ObservableObject {
    @Published var playerNames: [String]
    @Published var playerIsFilled: Bool
    
    init(playerNames: [String], playerIsFilled: Bool) {
        self.playerNames = playerNames
        self.playerIsFilled = playerIsFilled
    }
}

struct BeveledRectangle: Shape {
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bevelSize: CGFloat = 7.0
        
        path.move(to: CGPoint(x: rect.minX + bevelSize + xOffset, y: rect.minY + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - bevelSize + xOffset, y: rect.minY + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX + xOffset, y: rect.minY + bevelSize + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX + xOffset, y: rect.maxY - bevelSize + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX - bevelSize + xOffset, y: rect.maxY + yOffset))
        path.addLine(to: CGPoint(x: rect.minX + bevelSize + xOffset, y: rect.maxY + yOffset))
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.maxY - bevelSize + yOffset))
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.minY + bevelSize + yOffset))
        path.closeSubpath()
        
        return path
    }
}

struct ContentView: View {
    var backgroundColor = Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2)
    
    @StateObject var users = Users(playerNames: ["Alex", "Reb"], playerIsFilled: true)
    var body: some View {
        Color(backgroundColor)
            .ignoresSafeArea()
            .overlay(
                ZStack{
                    if(users.playerIsFilled){
                        HomeView()
                            .environmentObject(users)
                    } else {
                        LoginView()
                            .environmentObject(users)
                    }
                    
                    
                }
            )
    }
}

//Rectangle()
//  .fill(.black.opacity(0))
//  .background(Blur(radius:0, opaque: true))
//  .ignoresSafeArea()

struct LoginView: View {
    @State private var inputText: String = ""
    @State private var numberOfPlayers: Int = 0
    @State private var opacity: Double = 0
    
    @EnvironmentObject var users: Users
    var body: some View {
        VStack {
            if(numberOfPlayers == 0){
                Text("Combien de joueurs êtes vous ?")
                    .foregroundColor(.white)
                    .font(.system(size:24, weight: .bold)).italic()
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 0, x:3, y: 3)
                    .opacity(opacity)
                    .onAppear(){
                        withAnimation(.easeIn(duration: 0.3)){
                            opacity = 1
                        }
                    }
                
                AnimatedButton(characters: Array("1"), darkMode: false) {
                    print("Button pressed!")
                    withAnimation(.easeIn(duration: 0.3)){
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        numberOfPlayers = 1
                    }
                    users.playerNames = [""]
                    
                }
                .opacity(opacity)
                .padding()
                AnimatedButton(characters: Array("2"), darkMode: false) {
                    print("Button pressed!")
                    withAnimation(.easeIn(duration: 0.3)){
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        numberOfPlayers = 2
                    }
                    users.playerNames = ["", ""]
                }
                .padding()
                .opacity(opacity)
                
            } else {
                VStack{
                    Text("Entrez les pseudos des joueurs !")
                        .foregroundColor(.white)
                        .font(.system(size:24, weight: .bold)).italic()
                        .multilineTextAlignment(.center)
                        .shadow(color: .black, radius: 0, x:3, y: 3)
                        .opacity(opacity)
                        .onAppear(){
                            withAnimation(.easeIn(duration: 0.3)){
                                opacity = 1
                            }
                        }
                    ForEach(0..<numberOfPlayers, id:\.self) { index in
                        ZStack{
                            BeveledRectangle(xOffset: 0, yOffset: 0)
                                .stroke(Color.black, lineWidth: 20)
                                .frame(width:250, height: 80)
                            BeveledRectangle(xOffset: 0, yOffset: 0)
                                .stroke(Color.white, lineWidth: 8)
                                .frame(width:250, height: 80)
                            BeveledRectangle(xOffset: 0, yOffset: 0)
                                .fill(Color.black)
                                .offset(x: 0, y: 0)
                                .frame(width:250, height: 80)
                            if (users.playerNames[index].isEmpty) {
                                Text("Player \(index + 1)")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width:230, height: 80)
                                    .offset(x:-65)
                            }
                            TextField("", text: $users.playerNames[index])
                                .foregroundColor(Color.white)
                                .font(.system(size: 25, weight: .bold))
                                .frame(width:230, height: 80)
                                .textCase(.uppercase)
                            
                        }
                        .padding()
                        .opacity(opacity)
                        .onAppear(){
                            withAnimation(.easeIn(duration: 0.3)){
                                opacity = 1
                            }
                        }
                        
                    }
                    AnimatedButton(characters: Array("Valider !"), darkMode: false) {
                        print("Button pressed!")
                        users.playerIsFilled = true
                    }
                    .padding(.bottom)
                    .opacity(opacity)
                }
            }
            
        }

    }
}

struct RandomBlock: View {
    @State private var rotationAngle = 0.0
    @State private var scale = 0.0
    @State private var yOffset = -250.0
    
    
    var body: some View {
        ZStack {
            Image("circle")
                .resizable()
                .frame(width: 165, height: 165)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear() {
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        rotationAngle += 360
                    }
                }
            Image("circle_white")
                .resizable()
                .frame(width: 120.0, height: 120.0)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear() {
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        rotationAngle += 360
                    }

                }
        }
        .offset(y: yOffset)
        .scaleEffect(CGSize(width: scale, height: scale))
        .onAppear(){
            withAnimation(.easeInOut(duration:2)){
                yOffset += 450
                scale += 1
            }
        }
    }
}
struct HomeView: View {
    @EnvironmentObject var users: Users
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                OutlinedLabelView(text: users.playerNames[0], outlineColor: UIColor.black, outlineWidth: 12,
                                  font: UIFont.systemFont(ofSize: 30, weight: .bold))
                RandomBlock()
            }
            .offset(y: -250)
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            
            AnimatedButton(characters: Array("Ok!"), darkMode: false) {
                print("Button pressed!")
            }
            .padding(.bottom, 30)
            AnimatedButton(characters: Array("Perdu..."), darkMode: true) {
                print("Button pressed!")
            }
            Spacer()
        }
        .padding()
        .animation(.easeInOut(duration: 0.2), value: 0)
    }
}

struct AnimatedButton: View {
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    @State private var yOffsets: [CGFloat]
    
    let characters: [Character]
    let action: () -> Void
    let darkMode: Bool
    
    var backgroundColor = Color(.sRGB, red: 0, green: 1, blue: 0)
    
    
    init(characters: [Character], darkMode: Bool, action: @escaping () -> Void) {
        self.characters = characters
        self.action = action
        self.darkMode = darkMode
        _yOffsets = State(initialValue: Array(repeating: 0, count: characters.count))
    }
    
    
    var body: some View {
        ZStack {
            
            BeveledRectangle(xOffset: 5, yOffset: 5)
                .stroke(Color.black, lineWidth: 8)
            BeveledRectangle(xOffset: 0, yOffset: 0)
                .fill(darkMode ? Color.red : Color.white)
                .offset(x: xOffset, y: xOffset)
            BeveledRectangle(xOffset: 0, yOffset: 0)
                .stroke(Color.black, lineWidth: 5)
                .offset(x: xOffset, y: xOffset)
            
            HStack(spacing: 0) {
                ForEach(0..<characters.count, id: \.self) { index in
                    Text(String(characters[index]))
                        .font(.system(size: 25, weight: .bold))
                        .italic()
                        .foregroundColor(darkMode ? Color.white : Color.black)
                        .offset(x: xOffset, y: yOffsets[index] + yOffset)
                        .onAppear {
                            startInfiniteAnimation(for: index)
                        }
                }
            }
        }
        .frame(width: 250, height: 60)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        xOffset = 5
                        yOffset = 5
                    }
                    
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        xOffset = 0
                        yOffset = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        action()
                    }
                }
        )
    }
    
    func startInfiniteAnimation(for index: Int) {
        var totalDuration: Double = 3.0
        var singleJumpDuration: Double = 0.3
        var delayBetweenLetters: Double = 0.1
        
        if(darkMode){
            totalDuration = 10.0
            singleJumpDuration = 1.0
            delayBetweenLetters = 1.0
        }
        
        let delay = Double(index) * delayBetweenLetters
        
        Timer.scheduledTimer(withTimeInterval: totalDuration, repeats: true) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(Animation.easeInOut(duration: singleJumpDuration)) {
                    yOffsets[index] = -4
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + singleJumpDuration) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)) {
                        yOffsets[index] = 0
                    }
                    
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
