import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import net.reformedwitness.konfessio

Kirigami.ScrollablePage {
    id: root

    required property var confessionModel
    required property int chapterIndex
    required property string chapterNum
    required property string chapterTitle
    required property var sections

    signal navigateToPrevious()
    signal navigateToNext()

    title: chapterNum + ": " + chapterTitle

    actions: [
        Kirigami.Action {
            icon.name: "go-previous"
            text: "Previous"
            enabled: chapterIndex > 0
            onTriggered: root.navigateToPrevious()
            displayHint: Kirigami.DisplayHint.IconOnly
        },
        Kirigami.Action {
            icon.name: "go-next"
            text: "Next"
            enabled: confessionModel ? (chapterIndex < confessionModel.count - 1) : false
            onTriggered: root.navigateToNext()
            displayHint: Kirigami.DisplayHint.IconOnly
        }
    ]

    ColumnLayout {
        spacing: 0
        width: parent.width

        // Chapter header
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: applicationWindow().contentMaxWidthWide
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.largeSpacing * 3
            Layout.bottomMargin: Kirigami.Units.largeSpacing * 2
            Layout.leftMargin: Kirigami.Units.largeSpacing * 2
            Layout.rightMargin: Kirigami.Units.largeSpacing * 2
            spacing: Kirigami.Units.smallSpacing

            Controls.Label {
                text: "Chapter " + chapterNum
                font.pointSize: 11
                font.bold: true
                opacity: 0.6
                color: Kirigami.Theme.textColor
            }

            Kirigami.Heading {
                text: chapterTitle
                level: 1
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }

        // Sections
        Repeater {
            model: root.sections

            ColumnLayout {
                Layout.fillWidth: true
                Layout.maximumWidth: applicationWindow().contentMaxWidthWide
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                // Section header
                Kirigami.Heading {
                    visible: root.sections.length > 1 && AppSettings.showSectionHeaders
                    text: modelData && modelData.section ? ("Section " + modelData.section) : ""
                    level: 3
                    Layout.topMargin: Kirigami.Units.largeSpacing * 2
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                    Layout.leftMargin: Kirigami.Units.largeSpacing * 2
                    Layout.rightMargin: Kirigami.Units.largeSpacing * 2
                }

                // Section content
                Controls.Label {
                    text: modelData && modelData.content ? modelData.content : ""
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.largeSpacing * 2
                    Layout.rightMargin: Kirigami.Units.largeSpacing * 2
                    Layout.topMargin: (root.sections.length > 1 && AppSettings.showSectionHeaders) ? 0 : Kirigami.Units.largeSpacing * 2
                    Layout.bottomMargin: Kirigami.Units.largeSpacing * 2
                    font.pointSize: AppSettings.fontSize
                    lineHeight: 1.8
                    textFormat: Text.PlainText
                    color: Kirigami.Theme.textColor
                }
            }
        }

        // Navigation footer
        RowLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: applicationWindow().contentMaxWidthWide
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Kirigami.Units.largeSpacing * 2
            Layout.bottomMargin: Kirigami.Units.largeSpacing * 3
            Layout.leftMargin: Kirigami.Units.largeSpacing * 2
            Layout.rightMargin: Kirigami.Units.largeSpacing * 2
            spacing: Kirigami.Units.largeSpacing

            Controls.Button {
                icon.name: "go-previous"
                text: "Previous Chapter"
                enabled: chapterIndex > 0
                onClicked: root.navigateToPrevious()
                Layout.fillWidth: true
            }

            Controls.Button {
                icon.name: "go-next"
                text: "Next Chapter"
                enabled: confessionModel ? (chapterIndex < confessionModel.count - 1) : false
                onClicked: root.navigateToNext()
                Layout.fillWidth: true
            }
        }
    }
}
