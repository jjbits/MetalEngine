//
//  ViewController.swift
//  MetalEngine
//
//  Created by Joon Hwa Jung on 1/2/19.
//  Copyright © 2019 Joon Hwa Jung. All rights reserved.
//

import Cocoa
import MetalKit
import ModelIO

class ViewController: NSViewController {
  var mtkView: MTKView!
  var renderer: Renderer!

  override func viewDidLoad() {
    super.viewDidLoad()

    mtkView = MTKView()
    mtkView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(mtkView)
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
    
    // Do any additional setup after loading the view.
    let device = MTLCreateSystemDefaultDevice()!
    mtkView.device = device
    
    mtkView.colorPixelFormat = .bgra8Unorm_srgb
    mtkView.depthStencilPixelFormat = .depth32Float
    
    renderer = Renderer(view: mtkView, device: device)
    mtkView.delegate = renderer
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

