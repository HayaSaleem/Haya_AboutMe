//  V3
//  ContentView.swift
//  HayaApplication
//
//  Created by Haya Saleem Alhawiti on 13/07/1445 AH.
// *******Note: none of the images are copyrighted since they have been taken by me **********
//Click on "Follow" to view the animation :)
//Responsive design on all iphones
//Dark/Light Mode
//The language is changed according to the iPhone language settings
//To activate VoiceOver on the simulator:
//Go to xcode > open developer tool > Accessibility Inspector that vocalizes and selects elements on the simulator


import SwiftUI
//import SpriteKit

struct Star: Shape {
    
    func path(in rect: CGRect) -> Path {
        let (x, y, width, height) = rect.centeredSquare.flatten()
        let lowerPoint = CGPoint(x: x + width / 2, y: y + height)
        
        let path = Path { p in
            p.move(to: lowerPoint)
            p.addArc(center: CGPoint(x: x, y: (y + height)),
                     radius: (width / 2),
                     startAngle: .A360,
                     endAngle: .A270,
                     clockwise: true)
            p.addArc(center: CGPoint(x: x, y: y),
                     radius: (width / 2),
                     startAngle: .A90,
                     endAngle: .zero,
                     clockwise: true)
            
            p.addArc(center: CGPoint(x: x + width, y: y),
                     radius: (width / 2),
                     startAngle: .A180,
                     endAngle: .A90,
                     clockwise: true)

            p.addArc(center: CGPoint(x: x + width, y: y + height),
                     radius: (width / 2),
                     startAngle: .A270,
                     endAngle: .A180,
                     clockwise: true)

        }
        
        return path
    }
    
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
    
    var centeredSquare: CGRect {
        let width = ceil(min(size.width, size.height))
        let height = width
        
        let newOrigin = CGPoint(x: origin.x + (size.width - width) / 2, y: origin.y + (size.height - height) / 2)
        let newSize = CGSize(width: width, height: height)
        return CGRect(origin: newOrigin, size: newSize)
    }
    
    func flatten() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        return (origin.x, origin.y, size.width, size.height)
    }
}

extension Angle {
    static let A180 = Angle(radians: .pi)
    static let A90 = Angle(radians: .pi / 2)
    static let A270 = Angle(radians: (.pi / 2) * 3)
    static let A360 = Angle(radians: .pi * 2)
}

struct FollowButton: ViewModifier {
    @Binding var isFollowing: Bool
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                withAnimation {
                    isFollowing.toggle()
                }
            }
            .overlay(
                Star()
                    .fill(Color.white)
                    .opacity(isFollowing ? 1 : 0)
                    .rotationEffect(Angle.degrees(isFollowing ? 0 : -90))
                    .scaleEffect(isFollowing ? 1 : 0.1)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                    )
                    .frame(width: 35, height: 35)
                    .offset(x: isFollowing ? 0 : 20, y: isFollowing ? 0 : -20)
            )
    }
}

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
        @State private var isFollowing = false
        @State private var animateStars = false
        private var animationDuration = 0.5
        private var animationDelay = 0.2
    
    var body: some View {
        
        let backgroundColor = colorScheme == .dark ? Color.black : Color(red: 0.769, green: 0.769, blue: 0.769)
        
        ScrollView{
            VStack{
            
                VStack{
                    Image("Haya's_Memoji")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(Color.pink, lineWidth: 2)
                                .colorMultiply(colorScheme == .dark ? .white : .black)
                        )
                    
                    HStack {
                        Text(LocalizedStringKey("userName"))
                            .font(.title2)
                            .accessibilityLabel(LocalizedStringKey("userName"))
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.pink)
                            .font(.system(size: 18))
                            .accessibility(hidden: true)
                    }
                    Spacer()
                    Text(LocalizedStringKey("description"))
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50.0)
                        .accessibilityLabel(LocalizedStringKey("description"))
                    
                    Text(LocalizedStringKey("location"))
                        .padding(.top, 1.0)
                        .accessibilityLabel(LocalizedStringKey("location"))
                }
            }
            Spacer()
            
            VStack(spacing: 5) {
                HStack(spacing: 42.9) {
                    Text(LocalizedStringKey("postsNum"))
                        .font(.headline)
                        .accessibilityLabel(LocalizedStringKey("postsNum"))
                    Text("|")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Text(LocalizedStringKey("followersNum"))
                        .font(.headline)
                        .accessibilityLabel(LocalizedStringKey("followersNum"))
                    Text("|")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(LocalizedStringKey("followingNum"))
                        .font(.headline)
                        .accessibilityLabel(LocalizedStringKey("followingNum"))
                }
                HStack(spacing: 58) {
                    Text(LocalizedStringKey("postsTitle"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel(LocalizedStringKey("postsTitle"))
                    Text(LocalizedStringKey("followersTitle"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel(LocalizedStringKey("followersTitle"))
                    Text(LocalizedStringKey("followingTitle"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel(LocalizedStringKey("followingTitle"))
                }
            }
            .padding(.horizontal, 15)
            
            
            actionButton
            
            Bar()
        }
        
    }
    
    
    
    private var actionButton: some View {
        HStack {
            followButton
            messageButton
        }
    }

    private var followButton: some View {
        Button(action: toggleFollow) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(isFollowing ? Color.gray : Color.pink)
                    .frame(width: 180, height: 35)

                Text(LocalizedStringKey(isFollowing ? "unfollowAccount" : "followAccount"))
                       .foregroundColor(.white)
            }
        }
        .overlay(

            Star()
                .fill(Color.white)
                .opacity(isFollowing ? 1 : 0)
                .rotationEffect(Angle.degrees(isFollowing ? 0 : -90))
                .scaleEffect(isFollowing ? 1 : 0.1)
                .animation(Animation.easeInOut(duration: 0.5), value: isFollowing)
                .frame(width: 35, height: 35)
                .offset(x: isFollowing ? 0 : 20, y: isFollowing ? 0 : -20)
        )
    }


    private var messageButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.pink)
                .frame(width: 35, height: 35)
            
            Image(systemName: "envelope.fill")
                .foregroundColor(.white)
        }
    }

    private func toggleFollow() {
        isFollowing.toggle()

        if isFollowing {
           
            withAnimation {
                animateStars = true
            }

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
               
                if self.isFollowing {
                    withAnimation {
                        self.animateStars = false
                    }
                }
            }
        } else {
          
            withAnimation {
                animateStars = false
            }
        }
    }

    
}






struct Posts: View {
    let imageNames = [
         ["Image2", "Image3"],
          ["Bob&Tiki", "Tom"],
          ["Image", "HayaAlhawiti"]
          
      ]
    var body: some View {
        
        VStack(spacing: 12) {
            ForEach(imageNames, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { imageName in
                        ZStack(alignment: .bottomLeading) {
                            Image(imageName)
                                .resizable()
                                .frame(width: 180, height: 190)
                                .cornerRadius(16)
                                .padding(.horizontal,5)
                            
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [Color.black.opacity(0.7), Color.clear]
                                ),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .mask(
                                Rectangle()
                                    .frame(width: 180, height: 190)
                                    .cornerRadius(16)
                                
                            )
                            HStack(spacing:20) {
                            
                            
                            HStack {
                                Image(systemName: "eye")
                                    .foregroundColor(.pink)
                                    .font(.system(size: 10))
                                Text("\(Int.random(in: 1000...5000))")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            .padding(10)
                            .cornerRadius(8)
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 10))
                                Text("\(Int.random(in: 1000...5000))")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            .padding(10)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        }
                    }
                }
            }
        }
      
        
}
}

struct Likes: View {
    let imageNames2 = [
         ["Image3", "ProjImage"],

          
      ]
    var body: some View {
        
        VStack(spacing: 12) {
            ForEach(imageNames2, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { imageName in
                        ZStack(alignment: .bottomLeading) {
                            Image(imageName)
                                .resizable()
                                .frame(width: 180, height: 190)
                                .cornerRadius(16)
                                .padding(.horizontal,5)
                            
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [Color.black.opacity(0.7), Color.clear]
                                ),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .mask(
                                Rectangle()
                                    .frame(width: 180, height: 190)
                                    .cornerRadius(16)
                            )
                            HStack(spacing:20) {
                            
                            
                            HStack {
                                Image(systemName: "eye")
                                    .foregroundColor(.pink)
                                    .font(.system(size: 10))
                                Text("\(Int.random(in: 1000...5000))")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            .padding(10)
                            .cornerRadius(8)
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 10))
                                Text("\(Int.random(in: 1000...5000))")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            .padding(10)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        }
                    }
                }
            }
        }
  
    }
        
    }

struct Saved: View{
    var body: some View{
        
                VStack{
        
        
                    Text(LocalizedStringKey("privateSavedPosts"))
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.top, 100)
                        .padding(.horizontal)
                        .accessibilityLabel(LocalizedStringKey("privateSavedPosts"))

                        Spacer()
        
                    Text(LocalizedStringKey("savedMedia"))
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .accessibilityLabel(LocalizedStringKey("savedMedia"))
        
        
        
                }
        }
      
    }


struct Bar: View{
    @State var index = 1
    var body: some View{
        VStack(alignment: .leading, content: {
            HStack{
                
                Button(action:  {
                    self.index = 1
            
                }){
                    VStack(spacing:8){
                        HStack(spacing:12){
                            Image(systemName:"square.grid.2x2.fill")
                                .foregroundColor(self.index == 1 ? .pink : .gray)
                                .padding(.top, 20.0)
                                .font(.system(size: 25))
                                
                        }
                        Capsule()
                            .fill(self.index == 1 ? .pink : .gray)
                            .frame(height: 2)
                    }
                }
                
                Button(action:  {
                    self.index = 2
              
                }){
                    VStack(spacing:8){
                        HStack(spacing:12){
                            Image(systemName:"heart.fill")
                                .foregroundColor(self.index == 2 ? .pink : .gray)
                                .padding(.top, 20.0)
                            .font(.system(size: 25))
                            .foregroundColor(self.index == 2 ? Color.pink : Color.black.opacity(0.55))
                        }
                        Capsule()
                            .fill(self.index == 2 ? .pink : .gray)
                            .frame(height: 2)
                    }
                }
                
                Button(action:  {
                    self.index = 3
    
                }){
                    VStack(spacing:8){
                        
                        HStack(spacing:12){
                            
                            Image(systemName:"bookmark.fill")
                                .foregroundColor(self.index == 3 ? .pink : .gray)
                                .padding(.top, 17.0)
                            .font(.system(size: 25))
                            .foregroundColor(self.index == 3 ? Color.pink : Color.black.opacity(0.55))
                        }
                        Capsule()
                            .fill(self.index == 3 ? .pink : .gray)
                            .frame(height: 2)
                    }
                }
            }
            if index == 1 {
                Spacer()
                Spacer()
                Posts()
            } else if index == 2{
                Spacer()
                Spacer()
                Likes()
            }else{
                Saved()
            }
        })
        
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
          
            .padding(.top,-60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
