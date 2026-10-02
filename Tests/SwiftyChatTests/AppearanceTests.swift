import SwiftUI
import Testing
@testable import SwiftyChat

@Suite @MainActor struct AppearanceTests {
    @Test(arguments: [ColorScheme.light, .dark])
    func defaultTextRemainsReadable(in scheme: ColorScheme) {
        let style = ChatMessageCellStyle()
        let pairs: [(String, Color, Color)] = [
            ("Incoming text", style.incomingTextStyle.textStyle.textColor, style.incomingTextStyle.cellBackgroundColor),
            ("Outgoing text", style.outgoingTextStyle.textStyle.textColor, style.outgoingTextStyle.cellBackgroundColor),
            ("Image caption", style.imageTextCellStyle.textStyle.textColor, style.imageTextCellStyle.cellBackgroundColor),
            ("Contact name", style.contactCellStyle.fullNameLabelStyle.textColor, style.contactCellStyle.cellBackgroundColor),
            ("Carousel title", style.carouselCellStyle.titleLabelStyle.textColor, style.carouselCellStyle.cellBackgroundColor),
            ("Carousel subtitle", style.carouselCellStyle.subtitleLabelStyle.textColor, style.carouselCellStyle.cellBackgroundColor),
            ("Carousel action", style.carouselCellStyle.buttonTitleColor, style.carouselCellStyle.buttonBackgroundColor),
            ("Selected quick reply", style.quickReplyCellStyle.selectedItemColor, style.quickReplyCellStyle.selectedItemBackgroundColor),
            ("Quick reply", style.quickReplyCellStyle.unselectedItemColor, style.quickReplyCellStyle.unselectedItemBackgroundColor),
            ("Link title", style.linkPreviewCellStyle.titleStyle.textColor, style.linkPreviewCellStyle.cellBackgroundColor),
            ("Link description", style.linkPreviewCellStyle.descriptionStyle.textColor, style.linkPreviewCellStyle.cellBackgroundColor),
            ("Link host", style.linkPreviewCellStyle.hostStyle.textColor, style.linkPreviewCellStyle.cellBackgroundColor)
        ]
        var environment = EnvironmentValues()
        environment.colorScheme = scheme
        let canvas = scheme == .light ? [1.0, 1.0, 1.0] : [0.0, 0.0, 0.0]

        for (name, foreground, background) in pairs {
            let base = composite(background.resolve(in: environment), over: canvas)
            let text = composite(foreground.resolve(in: environment), over: base)
            let ratio = (max(luminance(text), luminance(base)) + 0.05)
                / (min(luminance(text), luminance(base)) + 0.05)
            #expect(ratio >= 4.5, "\(name) in \(scheme): \(ratio):1 contrast")
        }
    }

    private func composite(_ color: Color.Resolved, over background: [Double]) -> [Double] {
        zip([color.red, color.green, color.blue], background).map {
            Double($0) * Double(color.opacity) + $1 * (1 - Double(color.opacity))
        }
    }

    private func luminance(_ rgb: [Double]) -> Double {
        let linear = rgb.map { $0 <= 0.04045 ? $0 / 12.92 : pow(($0 + 0.055) / 1.055, 2.4) }
        return zip(linear, [0.2126, 0.7152, 0.0722]).map(*).reduce(0, +)
    }
}
