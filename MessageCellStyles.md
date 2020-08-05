## MessageKinds
* [Text](#text)
* [QuickReply](#quick-reply)
* [Carousel](#carousel)
* [Image](#image)
* [Location](#location)
* [Contact](#contact)


### Carousel

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/carouselItem.png)

<br>

```swift
public struct CarouselCellStyle {

    public let titleFont: Font                 // default = .title
    public let titleColor: Color               // default = .primary
    public let titleFontWeight: Font.Weight    // default = .bold
    
    public let subtitleFont: Font              // default = .body
    public let subtitleColor: Color            // default = .secondary
    public let subtitleFontWeight: Font.Weight // default = .regular
    
    public let buttonFont: Font                   // default = .body
    public let buttonTitleColor: Color            // default = .white
    public let buttonTitleFontWeight: Font.Weight // default = .semibold
    public let buttonBackgroundColor: Color       // default = .blue
    
    /// Cell width in a given available proxy (GeometryReader)
    public let cellWidth: (GeometryProxy) -> CGFloat
    // default = { $0.size.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellBackgroundColor: Color   // default = a whitish color
    public let cellCornerRadius:    CGFloat // default = 8
    public let cellBorderColor:     Color   // default = .clear
    public let cellBorderWidth:     CGFloat // default = 1
    public let cellShadowRadius:    CGFloat // default = 3
    public let cellShadowColor:     Color   // default = .secondary
}
```
CarouselCellStyle has both UIKit & SwiftUI initializers.

### Image

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/imageItem.png)

```swift
public struct ImageCellStyle {
    
    /// Cell width in a given available proxy (GeometryReader)
    public var cellWidth: (GeometryProxy) -> CGFloat
    // default = { $0.size.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellBackgroundColor: Color    // default = a whitish color
    public let cellCornerRadius:    CGFloat  // default = 8
    public let cellBorderColor:     Color    // default = .clear
    public let cellBorderWidth:     CGFloat  // default = 0
    public let cellShadowRadius:    CGFloat  // default = 2
    public let cellShadowColor:     Color    // default = .secondary
}
```
ImageCellStyle has both UIKit & SwiftUI initializers.

### Location

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/locationItem.png)

```swift
public struct LocationCellStyle {
    
    /// Cell width in a given available proxy (GeometryReader)
    public var cellWidth: (GeometryProxy) -> CGFloat
    // default = { $0.size.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellAspectRatio:  CGFloat   // default = 0.7
    public let cellCornerRadius: CGFloat   // default = 8
    public let cellBorderColor:  Color     // default = .clear
    public let cellBorderWidth:  CGFloat   // default = 0
    public let cellShadowRadius: CGFloat   // default = 2
    public let cellShadowColor:  Color     // default = .secondary
}
```
LocationCellStyle has both UIKit & SwiftUI initializers.
