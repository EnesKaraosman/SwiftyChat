## MessageKinds
* [text](#text)
* [quickReply](#quick-reply)
* [carousel](#carousel)
* [contact](#contact)


### Carousel

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/carouselItem.png)

<br>

```swift
public struct CarouselCellStyle {

    public let imageSize: CGSize
    
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
    
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
}
```
Both UIKit & SwiftUI initializers exist.
