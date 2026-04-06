import SwiftUI

struct FlowLayout: Layout {

    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    var alignment: HorizontalAlignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var height: CGFloat = 0
        var width: CGFloat = 0
        for (index, row) in rows.enumerated() {
            let rowWidth = row.reduce(CGFloat(0)) { $0 + $1.width } + CGFloat(max(row.count - 1, 0)) * horizontalSpacing
            width = max(width, rowWidth)
            height += row.map(\.height).max() ?? 0
            if index < rows.count - 1 {
                height += verticalSpacing
            }
        }
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        var subviewIndex = 0
        for (rowIndex, row) in rows.enumerated() {
            let rowWidth = row.reduce(CGFloat(0)) { $0 + $1.width } + CGFloat(max(row.count - 1, 0)) * horizontalSpacing
            let rowHeight = row.map(\.height).max() ?? 0
            let xOffset: CGFloat = switch alignment {
            case .trailing: bounds.maxX - rowWidth
            case .center: bounds.minX + (bounds.width - rowWidth) / 2
            default: bounds.minX
            }
            var x = xOffset
            for size in row {
                subviews[subviewIndex].place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(size)
                )
                x += size.width + horizontalSpacing
                subviewIndex += 1
            }
            y += rowHeight
            if rowIndex < rows.count - 1 {
                y += verticalSpacing
            }
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[CGSize]] {
        let maxWidth = proposal.replacingUnspecifiedDimensions().width
        var rows: [[CGSize]] = [[]]
        var currentRowWidth: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let spacingNeeded = rows[rows.count - 1].isEmpty ? 0 : horizontalSpacing
            if currentRowWidth + spacingNeeded + size.width > maxWidth, !rows[rows.count - 1].isEmpty {
                rows.append([])
                currentRowWidth = 0
            }
            rows[rows.count - 1].append(size)
            let spacingForThis = rows[rows.count - 1].count == 1 ? 0 : horizontalSpacing
            currentRowWidth += spacingForThis + size.width
        }
        return rows
    }
}
