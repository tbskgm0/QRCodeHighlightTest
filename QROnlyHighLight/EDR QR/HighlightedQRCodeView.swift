//
//  HighlightedQRCode.swift
//  QROnlyHighLight
//
//  Created by tsubasa.kogoma on 2022/11/19.
//

import SwiftUI

struct HighlightedQRCodeView: View {
    var qrCodeTextContent: String
    var imageRenderSize: CGSize
    var qrCodeScaleFactor: CGFloat

    var body: some View {
        let renderer = Renderer(imageProvider: { (scaleFactor: CGFloat, headroom: CGFloat) -> CIImage? in

            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            
            let inputData = qrCodeTextContent.data(using: .utf8)
            qrFilter.setValue(inputData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            
            guard let image = qrFilter.outputImage else { return nil }
            
            let sizeTransform = CGAffineTransform(scaleX: qrCodeScaleFactor, y: qrCodeScaleFactor)
            let qrImage = image.transformed(by: sizeTransform)
            
            let maxRGB = headroom
            guard let EDR_colorSpace = CGColorSpace(name: CGColorSpace.extendedLinearSRGB),
                                                    let maxFillColor = CIColor(red: maxRGB, green: maxRGB, blue: maxRGB, colorSpace: EDR_colorSpace) else {
                return nil
            }
            let fillImage = CIImage(color: maxFillColor)
            
            let maskFilter = CIFilter.blendWithMask()
            maskFilter.maskImage = qrImage
            maskFilter.inputImage = fillImage
            
            guard let combinedImage = maskFilter.outputImage else { return nil }
            return combinedImage.cropped(to: CGRect(
                x: 0,
                y: 0,
                width: imageRenderSize.width * scaleFactor,
                height: imageRenderSize.height * scaleFactor))
        })
        
        Metal_SwiftUICompatible(renderer: renderer)
    }
}
//
//struct HighlightedQRCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HighlightedQRCodeView()
//    }
//}
//
//struct Previews_HighlightedQRCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
