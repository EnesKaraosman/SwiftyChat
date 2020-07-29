## MessageKinds
* [Text](#text)
* [QuickReply](#quick-reply)
* [Carousel](#carousel)
* [Image](#image)
* [Contact](#contact)


### Carousel

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/carouselItem.png)

<br>

```swift
public struct CarouselCellStyle {

    public let titleFont: Font
    public let titleColor: Color
    public let titleFontWeight: Font.Weight
    
    public let subtitleFont: Font
    public let subtitleColor: Color
    public let subtitleFontWeight: Font.Weight
    
    public let buttonFont: Font
    public let buttonTitleColor: Color
    public let buttonTitleFontWeight: Font.Weight
    public let buttonBackgroundColor: Color
    
    /// Cell width in a given available proxy (GeometryReader)
    public let cellWidth: (GeometryProxy) -> CGFloat
    
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
}
```
CarouselCellStyle has both UIKit & SwiftUI initializers.

### Image

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/imageItem.png)

```swift
public struct ImageCellStyle {
    
    /// Cell width in a given available proxy (GeometryReader)
    public var cellWidth: (GeometryProxy) -> CGFloat
    
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
}
```
ImageCellStyle has both UIKit & SwiftUI initializers.
