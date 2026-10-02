# Style reference

`ChatMessageCellStyle` controls the appearance of each message kind. Inject it with `.environment(\.chatStyle, style)`. Its defaults work on light and dark system backgrounds; custom colors should be checked in both appearances.

## System appearance

Use semantic colors such as `.primary` for text on adaptive surfaces. Set foreground and background together when using a fixed fill. SwiftyChat inherits the host app's appearance and does not force a color scheme.

```swift
let style = ChatMessageCellStyle(
    incomingTextStyle: TextCellStyle(
        textStyle: CommonTextStyle(textColor: .primary),
        cellBackgroundColor: .secondary.opacity(0.1),
        cellCornerRadius: 16
    ),
    outgoingTextStyle: TextCellStyle(
        textStyle: CommonTextStyle(textColor: .white),
        cellBackgroundColor: Color(red: 0.08, green: 0.30, blue: 0.70),
        cellCornerRadius: 16
    ),
    imageTextCellStyle: ImageTextCellStyle(
        textStyle: CommonTextStyle(textColor: .primary)
    )
)
```

Test your host view with `.environment(\.colorScheme, .light)` and `.environment(\.colorScheme, .dark)` in previews. For a deliberately dark presentation with a fixed dark canvas, apply `.preferredColorScheme(.dark)` to that presentation so native controls, sheets, and semantic colors agree.

### Current defaults

The following samples are rendered from the library with local fixture content. They show the default styles, while the simulator screenshots below show the demo's custom styles.

| Component | Light | Dark |
|---|:---:|:---:|
| Text with links | <img src="Documentation/Images/components/text-link-light.png" width="280" alt="Underlined links in a light mode message"/> | <img src="Documentation/Images/components/text-link-dark.png" width="280" alt="Underlined links in a dark mode message"/> |
| Image caption | <img src="Documentation/Images/components/image-text-light.png" width="280" alt="Dark caption on a light card"/> | <img src="Documentation/Images/components/image-text-dark.png" width="280" alt="Light caption on a dark card"/> |
| Quick replies | <img src="Documentation/Images/components/quick-reply-light.png" width="280" alt="Quick replies in light mode"/> | <img src="Documentation/Images/components/quick-reply-dark.png" width="280" alt="Quick replies in dark mode"/> |
| Link preview | <img src="Documentation/Images/components/link-preview-light.png" width="280" alt="Link title, description and host in light mode"/> | <img src="Documentation/Images/components/link-preview-dark.png" width="280" alt="Link title, description and host in dark mode"/> |
| Video thumbnail | <img src="Documentation/Images/components/video-light.png" width="280" alt="Video play control over a bright thumbnail in light mode"/> | <img src="Documentation/Images/components/video-dark.png" width="280" alt="Video play control over a bright thumbnail in dark mode"/> |
| Active video | <img src="Documentation/Images/components/video-playing-light.png" width="280" alt="Readable playing indicator over a shaded thumbnail in light mode"/> | <img src="Documentation/Images/components/video-playing-dark.png" width="280" alt="Readable playing indicator over a shaded thumbnail in dark mode"/> |
| Reply quote | <img src="Documentation/Images/components/reply-light.png" width="280" alt="Reply quote and outgoing message in light mode"/> | <img src="Documentation/Images/components/reply-dark.png" width="280" alt="Reply quote and outgoing message in dark mode"/> |

<details>
<summary>More default components</summary>

| Component | Light | Dark |
|---|:---:|:---:|
| Text | <img src="Documentation/Images/components/text-light.png" width="280" alt="Text in light mode"/> | <img src="Documentation/Images/components/text-dark.png" width="280" alt="Text in dark mode"/> |
| Emoji | <img src="Documentation/Images/components/emoji-light.png" width="280" alt="Emoji in light mode"/> | <img src="Documentation/Images/components/emoji-dark.png" width="280" alt="Emoji in dark mode"/> |
| Image | <img src="Documentation/Images/components/image-light.png" width="280" alt="Image in light mode"/> | <img src="Documentation/Images/components/image-dark.png" width="280" alt="Image in dark mode"/> |
| Contact without actions | <img src="Documentation/Images/components/contact-light.png" width="280" alt="Contact without actions in light mode"/> | <img src="Documentation/Images/components/contact-dark.png" width="280" alt="Contact without actions in dark mode"/> |
| Loading | <img src="Documentation/Images/components/loading-light.png" width="280" alt="Loading in light mode"/> | <img src="Documentation/Images/components/loading-dark.png" width="280" alt="Loading in dark mode"/> |
| Custom content | <img src="Documentation/Images/components/custom-light.png" width="280" alt="Custom content in light mode"/> | <img src="Documentation/Images/components/custom-dark.png" width="280" alt="Custom content in dark mode"/> |

</details>

## Style types

Follow the source links for the complete, current initializer defaults.

| Style | Controls |
|---|---|
| [ChatMessageCellStyle](Sources/SwiftyChat/Styles/ChatMessageCellStyle.swift) | Incoming/outgoing text, message insets, per-kind styles, and avatars |
| [TextCellStyle](Sources/SwiftyChat/Styles/TextCellStyle.swift) | Font, foreground, padding, fill, selected corners, border, and shadow |
| [QuickReplyCellStyle](Sources/SwiftyChat/Styles/QuickReplyCellStyle.swift) | Selected/unselected colors and fonts, item size, border, and shadow; replies wrap to the available width |
| [CarouselCellStyle](Sources/SwiftyChat/Styles/CarouselCellStyle.swift) | Card width, title/subtitle styles, action foreground/background, and card decoration |
| [ImageCellStyle](Sources/SwiftyChat/Styles/ImageCellStyle.swift) | Image width, corners, border, and shadow |
| [ImageTextCellStyle](Sources/SwiftyChat/Styles/ImageTextCellStyle.swift) | Image card with caption text style and padding |
| [LocationCellStyle](Sources/SwiftyChat/Styles/LocationCellStyle.swift) | Map width, aspect ratio, corners, border, and shadow |
| [ContactCellStyle](Sources/SwiftyChat/Styles/ContactCellStyle.swift) | Card width, contact image, name style, and decoration |
| [AvatarStyle](Sources/SwiftyChat/Styles/AvatarStyle.swift) | Image style and alignment to the message's top, center, or bottom |
| [VideoPlaceholderCellStyle](Sources/SwiftyChat/Styles/VideoPlaceholderCellStyle.swift) | Thumbnail width, aspect ratio, blur, and decoration |
| [LinkPreviewCellStyle](Sources/SwiftyChat/Styles/LinkPreviewCellStyle.swift) | Title, description, host, image height, text padding, and card decoration |

Width closures receive the available chat size. Use that size when customizing layout so it works in split views, resized macOS windows, and device rotation.

```swift
let images = ImageCellStyle(cellWidth: { size in
    min(size.width * 0.75, 420)
})
```

## Demo themes

The demo includes five presets in [ChatThemes.swift](SwiftyChatDemo/SwiftyChatDemo/Themes/ChatThemes.swift). These are examples you can copy into your app, not exported library presets.

| Theme | Palette | Appearance |
|---|---|---|
| Modern | Blue with rounded bubbles | Follows the system |
| Classic | Blue with simple messaging bubbles | Follows the system |
| Dark Neon | Cyan on a dark canvas | Explicitly dark |
| Warm Sunset | Orange accents and deep orange action fills | Follows the system |
| Nature | Green accents and deep green action fills | Follows the system |

| Modern · light | Modern · dark | Dark Neon · light system |
|:---:|:---:|:---:|
| <img src="Documentation/Images/theme-modern-light.png" width="230" alt="Modern theme in light mode"/> | <img src="Documentation/Images/theme-modern-dark.png" width="230" alt="Modern theme in dark mode"/> | <img src="Documentation/Images/theme-neon-light.png" width="230" alt="Dark Neon correctly uses dark controls even with the system set to light"/> |

<details>
<summary>Classic, Warm Sunset, and Nature in both appearances</summary>

| Theme | Light | Dark |
|---|:---:|:---:|
| Classic | <img src="Documentation/Images/theme-classic-light.png" width="230" alt="Classic theme in light mode"/> | <img src="Documentation/Images/theme-classic-dark.png" width="230" alt="Classic theme in dark mode"/> |
| Warm Sunset | <img src="Documentation/Images/theme-sunset-light.png" width="230" alt="Warm Sunset theme in light mode"/> | <img src="Documentation/Images/theme-sunset-dark.png" width="230" alt="Warm Sunset theme in dark mode"/> |
| Nature | <img src="Documentation/Images/theme-nature-light.png" width="230" alt="Nature theme in light mode"/> | <img src="Documentation/Images/theme-nature-dark.png" width="230" alt="Nature theme in dark mode"/> |

</details>

## Native controls

Carousels, MapKit maps, text fields, and contact actions are checked in the running demo. SwiftUI's `ImageRenderer` does not render every native control, so the component render tests do not cover those controls.

| Contact actions · light | Contact actions · dark | Caption · light |
|:---:|:---:|:---:|
| <img src="Documentation/Images/gallery-contact-light.png" width="230" alt="Contact card with Call and Text actions in light mode"/> | <img src="Documentation/Images/gallery-contact-dark.png" width="230" alt="Contact card with Call and Text actions in dark mode"/> | <img src="Documentation/Images/gallery-caption-light.png" width="230" alt="Image caption in the running message gallery"/> |

The input stays above the software keyboard without moving messages over the theme header:

| Keyboard · light | Keyboard · dark |
|:---:|:---:|
| <img src="Documentation/Images/keyboard-light.png" width="230" alt="Theme header, sent message, and input remain visible above the light keyboard"/> | <img src="Documentation/Images/keyboard-dark.png" width="230" alt="Theme header, sent message, and input remain visible above the dark keyboard"/> |

More native captures: [caption in dark mode](Documentation/Images/gallery-caption-dark.png), [video in light mode](Documentation/Images/gallery-video-light.png), [video in dark mode](Documentation/Images/gallery-video-dark.png), and [Dark Neon with a dark system appearance](Documentation/Images/theme-neon-dark.png).

See [appearance testing and asset capture](Documentation/Appearance.md) to reproduce the screenshots and checks.
