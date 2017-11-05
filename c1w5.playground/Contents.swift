//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

var rgb = RGBAImage.init(image: image)!
let filter = ImageFilter(rgb: rgb)

//var newRgb = filter.desaturate(rgb, intensive: 0.1)
//var newRgb = filter.tweakColor(red: 0.2, green: 0.2, blue: 0.0).getRGBImage()
var newRgb = filter.blur(1).getRGBImage()

newRgb.toUIImage()
