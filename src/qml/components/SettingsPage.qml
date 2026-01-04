import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kirigami.delegates as KirigamiDelegates
import net.reformedwitness.konfessio

Kirigami.ScrollablePage {
    id: root

    title: "Settings"

    property int fontSize: 12
    property bool showSectionHeaders: true

    signal settingsChanged()

    // Back action
    actions: [
        Kirigami.Action {
            icon.name: "go-previous"
            text: "Back"
            onTriggered: {
                applicationWindow().pageStack.pop()
            }
        }
    ]

    ColumnLayout {
        width: parent.width
        spacing: Kirigami.Units.largeSpacing

        Kirigami.FormLayout {
            id: settingsForm
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 50
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: Kirigami.Units.largeSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing
            Layout.topMargin: Kirigami.Units.largeSpacing

            // Reading Section Header
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Reading"
            }

            // Font Size
            RowLayout {
                Kirigami.FormData.label: "Font size:"
                spacing: Kirigami.Units.largeSpacing

                Controls.Slider {
                    id: fontSizeSlider
                    Layout.fillWidth: true
                    from: 8
                    to: 20
                    value: root.fontSize
                    stepSize: 1
                    snapMode: Controls.Slider.SnapAlways

                    onValueChanged: {
                        root.fontSize = Math.round(value)
                        root.settingsChanged()
                    }
                }

                Controls.Label {
                    text: Math.round(fontSizeSlider.value) + " pt"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    font.bold: true
                }
            }

            // Font Size Preview
            Rectangle {
                Kirigami.FormData.label: "Preview:"
                Layout.fillWidth: true
                Layout.preferredHeight: previewLabel.implicitHeight + Kirigami.Units.largeSpacing * 2
                color: Kirigami.Theme.alternateBackgroundColor
                radius: Kirigami.Units.smallSpacing

                Controls.Label {
                    id: previewLabel
                    anchors.centerIn: parent
                    width: parent.width - Kirigami.Units.largeSpacing * 2
                    text: "The quick brown fox jumps over the lazy dog"
                    font.pointSize: root.fontSize
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Section Headers
            Controls.CheckBox {
                Kirigami.FormData.label: "Show section headers:"
                text: "Display headers when reading multi-section chapters"
                checked: root.showSectionHeaders
                onToggled: {
                    root.showSectionHeaders = checked
                    root.settingsChanged()
                }
            }

            // Appearance Section Header
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Appearance"
            }

            // Theme info
            Controls.Label {
                Kirigami.FormData.label: "Theme:"
                text: "Follows system settings"
                opacity: 0.7
            }

            // About Section Header
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "About"
            }

            // App name and version
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.largeSpacing

                    Kirigami.Icon {
                        source: "bookshelf"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.large
                        Layout.preferredHeight: Kirigami.Units.iconSizes.large
                        color: Kirigami.Theme.highlightColor
                    }

                    ColumnLayout {
                        spacing: Kirigami.Units.smallSpacing / 2

                        Kirigami.Heading {
                            text: "Konfessio"
                            level: 3
                        }

                        Controls.Label {
                            text: "Version 1.0.0"
                            font.pointSize: 9
                            opacity: 0.7
                        }
                    }
                }

                Controls.Label {
                    text: "A reader for historic Christian creeds, confessions, and catechisms"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.smallSpacing
                }

                Controls.Label {
                    text: "© 2025 Reformed Witness"
                    font.pointSize: 9
                    opacity: 0.6
                    Layout.topMargin: Kirigami.Units.smallSpacing
                }
            }

            // Reset Section
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
            }

            Kirigami.InlineMessage {
                id: resetSuccessMessage
                Layout.fillWidth: true
                type: Kirigami.MessageType.Positive
                text: "Settings have been reset to defaults"
                visible: false

                Timer {
                    id: resetSuccessTimer
                    interval: 3000
                    onTriggered: resetSuccessMessage.visible = false
                }
            }

            Controls.Button {
                text: "Reset to Defaults"
                icon.name: "edit-reset"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    resetConfirmDialog.open()
                }
            }

            // Bottom spacing
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.largeSpacing
            }
        }
    }

    Kirigami.PromptDialog {
        id: resetConfirmDialog
        title: "Reset Settings"
        subtitle: "Are you sure you want to reset all settings to their default values?"

        standardButtons: Controls.DialogButtonBox.Ok | Controls.DialogButtonBox.Cancel

        onAccepted: {
            AppSettings.reset()
            root.fontSize = AppSettings.fontSize
            root.showSectionHeaders = AppSettings.showSectionHeaders

            resetSuccessMessage.visible = true
            resetSuccessTimer.restart()
        }
    }
}
