//
//  ContentView.swift
//  QROnlyHighLight
//
//  Created by tsubasa.kogoma on 2022/11/19.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    let qrCodeText = "QRCode-test"

    init() {
        print("currentEDRHeadroom: \(UIScreen.main.currentEDRHeadroom)")
    }
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                if UIScreen.main.currentEDRHeadroom < 1 {
                    Text("this device is not supported.")
                    
                } else {
                    Text("EDR QR Code:")
                        .font(.headline)
                    HighlightedQRCodeView(
                        qrCodeTextContent: qrCodeText,
                        imageRenderSize: .init(width: 300, height: 300),
                        qrCodeScaleFactor: 15
                    )
                    .frame(width: 300, height: 300)
                }
            }

            Text("here is a regular QR Code")
                .font(.headline)
            Image(uiImage: generateQRCode(from: qrCodeText))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func generateQRCode(from string: String) -> UIImage {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data(string.utf8)
    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }
    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
