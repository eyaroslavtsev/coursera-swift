import Foundation

public final class ImageFilter {
    private var rgb: RGBAImage
    public init(rgb: RGBAImage) {
        self.rgb = rgb
    }
    
    public func desaturate(intensive: Double) -> ImageFilter {
        assert(intensive >= 0.0 && intensive <= 1.0, "parameter must be a value from 0.0 to 1.0")
        var newImage  = rgb.pixels
        for y in 0..<rgb.height {
            for x in 0..<rgb.width {
                let index = y*rgb.width+x
                var pixel = rgb.pixels[index]
                let m = UInt8(Double(max(pixel.red, pixel.green, pixel.blue))*intensive)
                pixel.red = m
                pixel.green = m
                pixel.blue = m
                newImage[index] = pixel
            }
        }
        rgb = RGBAImage(pixels: newImage, width: rgb.width, height: rgb.height)!
        return self
    }
    
    public func reverse() -> ImageFilter {
        var newImage  = rgb.pixels
        for y in 0..<rgb.height {
            for x in 0..<rgb.width {
                let index = y*rgb.width+x
                var pixel = rgb.pixels[index]
                pixel.red = 255 - pixel.red
                pixel.green = 255 - pixel.green
                pixel.blue = 255 - pixel.blue
                newImage[index] = pixel
            }
        }
        rgb = RGBAImage(pixels: newImage, width: rgb.width, height: rgb.height)!
        return self
    }

    public func tweakColor(red red: Double, green: Double, blue: Double) -> ImageFilter {
        assert(red >= 0.0 && red <= 1.0, "red parameter must be a value from 0.0 to 1.0")
        assert(green >= 0.0 && green <= 1.0, "green parameter must be a value from 0.0 to 1.0")
        assert(blue >= 0.0 && blue <= 1.0, "blue parameter must be a value from 0.0 to 1.0")
        var newImage  = rgb.pixels
        for y in 0..<rgb.height {
            for x in 0..<rgb.width {
                let index = y*rgb.width+x
                var pixel = rgb.pixels[index]
                
                pixel.red = toUInt8(Double(pixel.red)*(1.0+red))
                pixel.green = toUInt8(Double(pixel.green)*(1.0+green))
                pixel.blue = toUInt8(Double(pixel.blue)*(1.0+blue))
                newImage[index] = pixel
            }
        }
        rgb = RGBAImage(pixels: newImage, width: rgb.width, height: rgb.height)!
        return self
    }
    
    public func blur(let intensive: Double) -> ImageFilter {
        assert(intensive >= 0.0 && intensive <= 1.0, "intensive parameter must be a value from 0.0 to 1.0")
        var newImage  = rgb.pixels
        for y in 0..<rgb.height {
            for x in 0..<rgb.width {
                var nRed: UInt = 0
                var nGreen: UInt = 0
                var nBlue: UInt = 0
                var nPixelsCount: UInt = 1
                let index = y*rgb.width+x
                var pixel = rgb.pixels[index]
                for nY in -1...1 {
                    for nX in -1...1 {
                        let diffY = nY+y
                        let diffX = nX+x
                        if(nX != 0 || nY != 0) {
                            if diffX >= 0 && diffY >= 0 && diffX < rgb.width && diffY < rgb.height {
                                let nIndex = diffY*rgb.width+diffX
                                nRed+=UInt(rgb.pixels[nIndex].red)
                                nGreen+=UInt(rgb.pixels[nIndex].green)
                                nBlue+=UInt(rgb.pixels[nIndex].blue)
                                nPixelsCount+=1
                            }
                        }
                    }
                }
                
                let averageRed = UInt8(nRed/nPixelsCount)
                let averageGreen = UInt8(nGreen/nPixelsCount)
                let averageBlue = UInt8(nBlue/nPixelsCount)
                
                pixel.red = applyIntensive(pixel.red, average: averageRed, intensive: intensive)
                pixel.green = applyIntensive(pixel.green, average: averageGreen, intensive: intensive)
                pixel.blue = applyIntensive(pixel.blue, average: averageBlue, intensive: intensive)
                
                newImage[index] = pixel
            }
        }
        
        rgb = RGBAImage(pixels: newImage, width: rgb.width, height: rgb.height)!
        return self
    }
    
    private func applyIntensive(color: UInt8, average: UInt8, intensive: Double) -> UInt8 {
        let revIntensive = 1 - intensive
        if(average > color) {
            let diff = UInt8(Double(average - color)*revIntensive)
            return average - diff
        } else {
            let diff = UInt8(Double(color - average)*revIntensive)
            return average + diff
        }
    }
    
    private func toUInt8(i:Double) -> UInt8 {
        if(i > 255) {
            return 255
        } else {
            return UInt8(i)
        }
    }
    
    public func getRGBImage() -> RGBAImage {
        return rgb
    }
}