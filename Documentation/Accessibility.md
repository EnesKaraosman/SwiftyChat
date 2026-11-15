# Accessibility

SwiftyChat uses semantic SwiftUI text styles and native controls so apps can use the system's Dynamic Type and VoiceOver support. At accessibility text sizes, contact actions stack vertically; contact and quick-reply controls expand to at least 44 points, video controls are 44 points tall, and link-preview and carousel text is no longer clipped to a fixed line count.

Interactive message labels include the contact action's title, a reply quote's author and text, the delivery status and retry action, and the link preview's title, description, and host. Decorative contact-card chevrons are hidden from accessibility.

The Message Types demo also stacks its add-message and sender controls at accessibility text sizes. A smoke flow checks that contact actions remain visible and usable at the largest accessibility text size:

```sh
xcrun simctl ui <simulator-udid> content_size accessibility-extra-extra-extra-large
maestro test --udid <simulator-udid> -e OUTPUT_DIR=/private/tmp Tests/Smoke/accessibility.yaml
xcrun simctl ui <simulator-udid> content_size large
```

The flow checks the accessibility tree and activates the controls. It captures a screenshot at `/private/tmp/contact-accessibility.png`. VoiceOver speech order and focus retention after jumping to a quoted or latest message still need a hands-on VoiceOver pass on iOS; UI automation alone does not establish those behaviors. Styles that apps replace with fixed-size custom fonts also need app-specific review.
