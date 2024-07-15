//
//  ContentView.swift
//  Image Redraw Playground
//
//  Created by Zachary Gibson on 7/15/24.
//

import SwiftUI

enum ImageAction: String {
    case writeMonochromaticImage
    case writePolychromaticImage
    case removeImage
}

struct ContentView: View {
    let imageURL = URL.documentsDirectory.appending(component: "spidey.png")
    @State var imageAction: ImageAction? = nil
    
    var body: some View {
        VStack {
            if let imageAction = imageAction {
                Text(imageAction.rawValue)
            }
            AsyncImage(url: imageURL) { imagePhase in
                switch imagePhase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                case .empty:
                    Color.red
                        .frame(maxHeight: 300)
                case .failure:
                    Color.red
                        .frame(maxHeight: 300)
                }
            }
            Button("Remove Image Data") {
                imageAction = .removeImage
            }
            Button("Update Image Data") {
                if imageAction == .writePolychromaticImage {
                    imageAction = .writeMonochromaticImage
                } else {
                    imageAction = .writePolychromaticImage
                }
            }
            .onChange(of: imageAction) { oldValue, newValue in
                switch newValue {
                case .writeMonochromaticImage:
                    if let imageData = UIImage(resource: .monoChromaticSpidey).pngData() {
                        writeImageToDisk(data: imageData)
                    }
                case .writePolychromaticImage:
                    if let imageData = UIImage(resource: .polyChromaticSpidey).pngData() {
                        writeImageToDisk(data: imageData)
                    }
                case .removeImage:
                    removeImageFromDisk()
                case .none:
                    break
                }
            }
        }
        .padding()
    }
    func writeImageToDisk(data: Data) {
        FileManager.default.createFile(atPath: imageURL.path(), contents: data)
    }
    func removeImageFromDisk() {
        try! FileManager.default.removeItem(at: imageURL)
    }
}

#Preview {
    ContentView()
}
