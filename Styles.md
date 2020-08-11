## Styles
* [Text](#text)
* [QuickReply](#quick-reply)
* [Carousel](#carousel)
* [Image](#image)
* [Location](#location)
* [Contact](#contact)
* [Avatar](#avatar)


### QuickReply

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/quickReplyItem.png)

```swift
public struct QuickReplyCellStyle {

    /// If the total characters of all item's title is greater than this value, items ordered vertically
    public let characterLimitToChangeStackOrientation: Int
    // default = 30
    
    public let selectedItemColor: Color // default = .green
    public let selectedItemFont: Font   // default = .callout
    public let selectedItemFontWeight: Font.Weight // default = .semibold
    public let selectedItemBackgroundColor: Color  // default = Color.green.opacity(0.3)

    public let unselectedItemColor: Color // default = .primary
    public let unselectedItemFont: Font   // default = .callout
    public let unselectedItemFontWeight: Font.Weight // default = .semibold
    public let unselectedItemBackgroundColor: Color  // default = .clear

    public let itemPadding:         CGFloat // default = 8
    public let itemBorderWidth:     CGFloat // default = 1
    public let itemHeight:          CGFloat // default = 40
    public let itemCornerRadius:    CGFloat // default = 8
    public let itemShadowColor:     Color   // default = .secondary
    public let itemShadowRadius:    CGFloat // default = 1
    
}
```

### Carousel

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/carouselItem.png)

```swift
public struct CarouselCellStyle {

    public let titleLabelStyle: CommonLabelStyle 
    // default = font: .title, color: .primary, fontWeight: .bold
    
    public let subtitleLabelStyle: CommonLabelStyle
    // default = font: .body, color: .secondary, fontWeight: .regular
    
    public let buttonFont: Font                   // default = .body
    public let buttonTitleColor: Color            // default = .white
    public let buttonTitleFontWeight: Font.Weight // default = .semibold
    public let buttonBackgroundColor: Color       // default = .blue
    
    /// Cell width in a given available size
    public let cellWidth: (CGSize) -> CGFloat
    // default = { $0.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellBackgroundColor: Color   
    // default = Color.secondary.opacity(0.2)
    
    public let cellCornerRadius:    CGFloat // default = 8
    public let cellBorderColor:     Color   // default = .clear
    public let cellBorderWidth:     CGFloat // default = 1
    public let cellShadowRadius:    CGFloat // default = 3
    public let cellShadowColor:     Color   // default = .secondary
}
```

### Image

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/imageItem.png)

```swift
public struct ImageCellStyle {
    
    /// Cell width in a given available size
    public let cellWidth: (CGSize) -> CGFloat
    // default = { $0.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellBackgroundColor: Color    
    // default = Color.secondary.opacity(0.1)
    
    public let cellCornerRadius:    CGFloat  // default = 8
    public let cellBorderColor:     Color    // default = .clear
    public let cellBorderWidth:     CGFloat  // default = 0
    public let cellShadowRadius:    CGFloat  // default = 3
    public let cellShadowColor:     Color    // default = .secondary
}
```

### Location

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/locationItem.png)

```swift
public struct LocationCellStyle {
    
    /// Cell width in a given available size
    public let cellWidth: (CGSize) -> CGFloat
    // default = { $0.width * (UIDevice.isLandscape ? 0.4 : 0.75) }
    
    public let cellAspectRatio:  CGFloat   // default = 0.7
    public let cellCornerRadius: CGFloat   // default = 8
    public let cellBorderColor:  Color     // default = .clear
    public let cellBorderWidth:  CGFloat   // default = 0
    public let cellShadowRadius: CGFloat   // default = 2
    public let cellShadowColor:  Color     // default = .secondary
}
```

### Contact

![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/contactItem.png)

```swift
public struct ContactCellStyle {

    public let cellWidth: (CGSize) -> CGFloat
    //default = { $0.width * (UIDevice.isLandscape ? 0.45 : 0.75) }
    
    public let imageStyle: CommonImageStyle
    
    public let fullNameLabelStyle: CommonLabelStyle
    // default = font: .body, color: .primary, fontWeight: .semibold
    
}
```

### Avatar

```swift
public enum AvatarPosition {
    case alignToMessageCenter(spacing: CGFloat)
    case alignToMessageTop(spacing: CGFloat)
    case alignToMessageBottom(spacing: CGFloat)
}

public struct AvatarStyle {
    public let imageStyle: CommonImageStyle
    public let avatarPosition: AvatarPosition 
    // default = .alignToMessageBottom(spacing: 8)
}
```

