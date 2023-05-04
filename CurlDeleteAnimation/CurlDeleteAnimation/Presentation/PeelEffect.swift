//
//  PeelEffect.swift
//  CurlDeleteAnimation
//
//  Created by Rob Copping on 02/05/2023.
//

import SwiftUI

struct PeelEffect<Content: View>: View {
    var content: Content
    var onDelete: () -> ()

    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }

    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded = false

    var body: some View {
       content
            .hidden()
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)

                   deleteView

                    Rectangle()
                        .fill(.black)
                        .padding(.vertical, 25)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                        .padding(.trailing, rect.width * dragProgress)
                        .mask(content)
                        .allowsHitTesting(false)


                    content
                        .mask {
                            Rectangle()
                                .padding(.trailing, dragProgress * rect.width)
                        }
                        .allowsHitTesting(false)
                }
            }
            .overlay {
                reversedImage
            }
    }

    var deleteView: some View {
        GeometryReader {
            let rect = $0.frame(in: .global)
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.red.gradient)
                .overlay(alignment: .trailing) {
                    Button {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            dragProgress = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.trailing)
                            .foregroundColor(.white)
                    }
                }
                .disabled(!isExpanded)
                .padding(10)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isExpanded else { return }
                            var translationX = value.translation.width
                            translationX = max(-translationX, 0)
                            let progress = min(1, translationX / rect.width)
                            dragProgress = progress
                        }
                        .onEnded { value in
                            guard !isExpanded else { return }
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                if dragProgress > 0.75 {
                                    onDelete()
                                    isExpanded = false
                                } else if dragProgress > 0.25 {
                                    dragProgress = 0.6
                                    isExpanded = true
                                } else {
                                    dragProgress = .zero
                                    isExpanded = false
                                }
                            }
                        }
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        isExpanded = false
                        dragProgress = 0
                    }
                }
        }
    }

    var reversedImage: some View {
        GeometryReader {
            let size = $0.size
            let minOpactity = dragProgress / 0.05
            let opacity = max(1, minOpactity)

            content
                .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                .overlay {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .mask(content)
                }
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                .clear, .white, .clear, .clear
                            ], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 60)
                        .offset(x: 40)
                        .offset(x: -30 * (30 * opacity))
                        .offset(x: size.width * -dragProgress)
                }
                .scaleEffect(x: -1)
                .offset(x: size.width - (size.width * dragProgress))
                .offset(x: size.width * -dragProgress)
                .mask {
                    Rectangle()
                        .offset(x: size.width * -dragProgress)
                }
        }
        .allowsHitTesting(false)
    }
}

struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
