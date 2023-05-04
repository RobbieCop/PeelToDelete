//
//  HomeView.swift
//  CurlDeleteAnimation
//
//  Created by Rob Copping on 02/05/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var images: [ImageModel] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(images, id: \.id) { image in
                    PeelEffect {
                        cardView(image)
                    } onDelete: {
                        withAnimation(.easeInOut) {
                            images.removeAll(where: { $0.id == image.id })
                        }
                    }
                }
            }
            .padding(20)
        }
        .onAppear {
            for index in 1...4 {
                images.append(.init(assetName: "pic\(index)"))
            }
        }
    }

    func cardView(_ imageModel: ImageModel) -> some View {
        GeometryReader {
            let size  = $0.size
            ZStack {
                Image(imageModel.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .clipped()
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
