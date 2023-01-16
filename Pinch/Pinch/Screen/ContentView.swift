//
//  ContentView.swift
//  Pinch
//
//  Created by Vikas Vaish on 28/11/22.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTY
    @State private var isAnimated: Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset:CGSize = .zero
    @State private var isDrawerOpen:Bool = false
    let pages : [Page] = PageData
    @State private var pageIndex: Int = 1
    
    
    
    //MARK: - FUNCTION
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String{
        return pages[pageIndex - 1].imageName
    }
    
    //MARK: - CONTENT
    
    var body: some View {
        NavigationView{
            ZStack{
                
                Color.clear
                
                //MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12,x:2,y: 2)
                    .opacity(isAnimated ? 1:0)
                    .offset(x: imageOffset.width,y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                //MARK: - Tap Gesture
                    .onTapGesture(count: 2,perform: {
                        if imageScale == 1{
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                            resetImageState()
                        }
                    })
                //            MARK: -  Drag gesture
                    .gesture(
                        DragGesture()
                            .onChanged{
                                value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{ _ in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            }
                    )
                //                MARK: -  MAGNIFICATION
                    .gesture(MagnificationGesture()
                        .onChanged{value in
                            withAnimation(.linear(duration: 1)){
                                if imageScale >= 1 && imageScale<=5 {
                                    imageScale = value
                                }else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                        .onEnded{_ in
                            if imageScale > 5{
                                imageScale = 5
                            } else if imageScale <= 1{
                                resetImageState()
                            }
                        }
                    )
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)){
                    isAnimated = true
                }
            })
            
            // MARK: - INFO PANEL
            .overlay(InfoPanelView(scale: imageScale, offset: imageOffset)
                .padding(.top,30)
                .padding(.horizontal),alignment: .top)
            
            
           
            // MARK: - CONTROLS
            .overlay( Group {
                HStack {
                    //  SCALE DOWN
                    Button {
                        // some  action
                        withAnimation(.spring()){
                            if imageScale > 1{
                                imageScale -= 1
                            }
                            if imageScale <= 1{
                                resetImageState()
                            }
                        }
                        
                        
                    }label: {
                        ControlImageView(icon: "minus.magnifyingglass")
                    }
                    
                    // RESET
                    Button {
                        // some  action
                        resetImageState()
                        
                    }label: {
                        ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                    }
                    
                    //SCALE UP
                    Button {
                        // some  action
                        withAnimation(.spring()){
                            if imageScale < 5{
                                imageScale += 1
                            }
                            if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                        
                    }label: {
                        ControlImageView(icon: "plus.magnifyingglass")
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 20))
                .opacity(isAnimated ? 1 : 0)
                //: CONTROLS
            }
                .padding(.bottom,30),alignment: .bottom
            )
            
            
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12){
                    Image(systemName: isDrawerOpen ? "chevron.compact.right":"chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height:40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        })
                    //MARK: - THUMBNAILS
                    ForEach(pages) { item in
                        Image(item.thumbNailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1: 0)
                            .animation(.easeOut(duration:0.5),value:isDrawerOpen)
                            .onTapGesture(perform: {
                                isAnimated = true
                                pageIndex = item.id
                            })
                        
                    }
                    Spacer()
                }//: DRAWER
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimated ? 1:0)
                    .frame(width: 260)
                    .padding(.top,UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                ,alignment: .topTrailing
                
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
