//
//  Metal_SwiftUICompatible.swift
//  QROnlyHighLight
//
//  Created by tsubasa.kogoma on 2022/11/19.
//

import SwiftUI
import MetalKit

struct Metal_SwiftUICompatible: UIViewRepresentable {
    @StateObject var renderer: Renderer
    
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: renderer.device)
        
        view.preferredFramesPerSecond = 10
        
        view.framebufferOnly = false
        view.delegate = renderer
        
        if let layer = view.layer as? CAMetalLayer {
            if #available(iOS 16.0, *) {
                layer.wantsExtendedDynamicRangeContent = true
            }
            layer.colorspace = CGColorSpace(name: CGColorSpace.extendedDisplayP3)
            view.colorPixelFormat = MTLPixelFormat.rgba16Float
        }
        return view
    }
    
    func updateUIView(_ view: MTKView, context: Context) {
        configure(view: view, renderer: renderer)
    }
    
    private func configure(view: MTKView, renderer: Renderer) {
        view.delegate = renderer
    }
}
