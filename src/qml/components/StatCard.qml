import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import net.reformedwitness.konfessio

Kirigami.Card {
    id: root

    required property string iconName
    required property string title
    required property string value

    Layout.fillWidth: true
    Layout.preferredHeight: 120

    property bool cardHovered: false

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: root.cardHovered = hovered
    }

    z: cardHovered ? 2 : 1

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Kirigami.Theme.highlightColor
        border.width: cardHovered ? 1 : 0
        radius: Kirigami.Units.smallSpacing
        opacity: 0.3
    }

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                source: root.iconName
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                color: Kirigami.Theme.highlightColor
                scale: root.cardHovered ? 1.1 : 1.0
            }

            Kirigami.Heading {
                text: root.title
                level: 3
            }
        }

        Controls.Label {
            text: root.value
            font.pointSize: 16
            font.bold: true
        }
    }
}
