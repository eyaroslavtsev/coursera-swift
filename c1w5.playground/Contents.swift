//: Playground - noun: a place where people can play

import UIKit

//STEP 1
let image = UIImage(named: "sample")!

var rgb = RGBAImage.init(image: image)!

//STEP 2, filters 3 different filters
ImageProcessor(rgb: rgb).desaturate(0.9).getRGBImage().toUIImage()

ImageProcessor(rgb: rgb).blur(1).getRGBImage().toUIImage()

ImageProcessor(rgb: rgb).tweakColor(red: 0.2, green: 0.2, blue: 0.0).getRGBImage().toUIImage()

//STEP 3 blur + desaturate
ImageProcessor(rgb: rgb).blur(1).desaturate(0.9).getRGBImage().toUIImage()

//STEP 4, STEP 5 predifined filters
ImageProcessor(rgb: rgb).applyPredifined("desaturateWithIntensive50%").getRGBImage().toUIImage()
