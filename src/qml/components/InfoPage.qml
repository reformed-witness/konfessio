import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import net.reformedwitness.konfessio

Kirigami.ScrollablePage {
    id: root

    required property var confessionModel

    title: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.title || "Konfessio") : "Konfessio"

    ColumnLayout {
        width: parent.width
        spacing: Kirigami.Units.largeSpacing * 2

        // Hero section
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 280

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Kirigami.Theme.highlightColor }
                    GradientStop { position: 1.0; color: Qt.darker(Kirigami.Theme.highlightColor, 1.5) }
                }
                opacity: 0.15
            }

            // Decorative background circles
            Repeater {
                model: 3
                Rectangle {
                    x: parent.width * (0.2 + index * 0.3) - width/2
                    y: parent.height * 0.5 - height/2
                    width: 120 + index * 40
                    height: width
                    radius: width / 2
                    color: Kirigami.Theme.highlightColor
                    opacity: 0.04
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - Kirigami.Units.largeSpacing * 2, applicationWindow().contentMaxWidthNarrow)
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Icon {
                    source: "bookshelf"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.enormous
                    Layout.preferredHeight: Kirigami.Units.iconSizes.enormous
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.highlightColor
                    opacity: 0.9
                }

                Kirigami.Heading {
                    text: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.title || "Historic Creeds & Confessions") : "Historic Creeds & Confessions"
                    level: 1
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    font.weight: Font.Bold
                }

                Controls.Label {
                    text: root.confessionModel && root.confessionModel.metadata && root.confessionModel.metadata.year ?
                          ("Published " + root.confessionModel.metadata.year) : ""
                    visible: text !== ""
                    font.pointSize: 12
                    opacity: 0.85
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }

        // Metadata cards in a grid
        GridLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: applicationWindow().contentMaxWidthWide
            Layout.leftMargin: Kirigami.Units.largeSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing
            columns: 2
            rowSpacing: Kirigami.Units.largeSpacing
            columnSpacing: Kirigami.Units.largeSpacing

            StatCard {
                iconName: "format-list-ordered"
                title: "Chapters"
                value: root.confessionModel ? (root.confessionModel.count + " chapters") : "0 chapters"
            }

            StatCard {
                iconName: "document-properties"
                title: "Type"
                value: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.creedFormat || "Confession") : "Confession"
            }
        }

        // Timeline and Location section
        GridLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: applicationWindow().contentMaxWidthWide
            Layout.leftMargin: Kirigami.Units.largeSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing
            columns: 2
            rowSpacing: Kirigami.Units.largeSpacing
            columnSpacing: Kirigami.Units.largeSpacing

            // Timeline Card
            Kirigami.Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 200

                header: Item {
                    implicitHeight: headerLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
                    implicitWidth: headerLayout.implicitWidth

                    RowLayout {
                        id: headerLayout
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.largeSpacing
                        spacing: Kirigami.Units.largeSpacing

                        Kirigami.Icon {
                            source: "view-calendar-timeline"
                            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                            color: Kirigami.Theme.highlightColor
                        }

                        Kirigami.Heading {
                            text: "Timeline"
                            level: 2
                        }
                    }
                }

                contentItem: Item {
                    ColumnLayout {
                        anchors.centerIn: parent
                        width: parent.width - Kirigami.Units.largeSpacing * 4
                        spacing: Kirigami.Units.largeSpacing

                        // Timeline visualization
                        Rectangle {
                            id: timelineBar
                            Layout.fillWidth: true
                            Layout.preferredHeight: 4
                            color: Kirigami.Theme.highlightColor
                            opacity: 0.3
                            radius: 2

                            property int year: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.year || 1600) : 1600
                            property int minYear: Math.floor(year / 500) * 500
                            property int maxYear: Math.ceil(year / 500) * 500

                            Rectangle {
                                width: 16
                                height: 16
                                radius: 8
                                color: Kirigami.Theme.highlightColor
                                anchors.verticalCenter: parent.verticalCenter
                                x: {
                                    var range = parent.maxYear - parent.minYear
                                    if (range === 0) return parent.width / 2 - width / 2
                                    var position = (parent.year - parent.minYear) / range
                                    return parent.width * position - width / 2
                                }

                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: Kirigami.Theme.backgroundColor
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Controls.Label {
                                text: timelineBar.minYear.toString()
                                font.pointSize: 9
                                opacity: 0.6
                            }

                            Item { Layout.fillWidth: true }

                            ColumnLayout {
                                spacing: Kirigami.Units.smallSpacing

                                Controls.Label {
                                    text: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.year || "") : ""
                                    font.pointSize: 20
                                    font.bold: true
                                    color: Kirigami.Theme.highlightColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Controls.Label {
                                    text: "Published"
                                    font.pointSize: 9
                                    opacity: 0.6
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            Item { Layout.fillWidth: true }

                            Controls.Label {
                                text: timelineBar.maxYear.toString()
                                font.pointSize: 9
                                opacity: 0.6
                            }
                        }
                    }
                }
            }

            // Map/Location Card
            Kirigami.Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 200

                header: Item {
                    implicitHeight: locationHeaderLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
                    implicitWidth: locationHeaderLayout.implicitWidth

                    RowLayout {
                        id: locationHeaderLayout
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.largeSpacing
                        spacing: Kirigami.Units.largeSpacing

                        Kirigami.Icon {
                            source: "find-location"
                            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                            color: Kirigami.Theme.highlightColor
                        }

                        Kirigami.Heading {
                            text: "Location"
                            level: 2
                        }
                    }
                }

                contentItem: Item {
                    // Simple map visualization
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.largeSpacing * 2
                        color: Kirigami.Theme.alternateBackgroundColor
                        radius: 4

                        // Stylized map background
                        Column {
                            anchors.centerIn: parent
                            spacing: Kirigami.Units.smallSpacing / 2

                            Repeater {
                                model: 6
                                Rectangle {
                                    width: 80
                                    height: 1
                                    color: Kirigami.Theme.textColor
                                    opacity: 0.1
                                }
                            }
                        }

                        // Location marker
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Kirigami.Units.smallSpacing

                            Kirigami.Icon {
                                source: "map-marker"
                                Layout.preferredWidth: Kirigami.Units.iconSizes.large
                                Layout.preferredHeight: Kirigami.Units.iconSizes.large
                                Layout.alignment: Qt.AlignHCenter
                                color: Kirigami.Theme.negativeTextColor
                            }

                            Controls.Label {
                                text: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.location || "") : ""
                                font.pointSize: 11
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }

        // Authors section
        Kirigami.Card {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: applicationWindow().contentMaxWidthWide
            Layout.leftMargin: Kirigami.Units.largeSpacing
            Layout.rightMargin: Kirigami.Units.largeSpacing
            visible: (root.confessionModel && root.confessionModel.metadata && root.confessionModel.metadata.authors) ? (root.confessionModel.metadata.authors.length > 0) : false

            header: Item {
                implicitHeight: authorsHeaderLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
                implicitWidth: authorsHeaderLayout.implicitWidth

                RowLayout {
                    id: authorsHeaderLayout
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    spacing: Kirigami.Units.largeSpacing

                    Kirigami.Icon {
                        source: "user-group-properties"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                        color: Kirigami.Theme.highlightColor
                    }

                    Kirigami.Heading {
                        text: "Authors & Contributors"
                        level: 2
                    }
                }
            }

            contentItem: Flow {
                spacing: Kirigami.Units.smallSpacing
                padding: Kirigami.Units.largeSpacing

                Repeater {
                    model: root.confessionModel && root.confessionModel.metadata ? (root.confessionModel.metadata.authors || []) : []

                    Kirigami.Chip {
                        text: modelData
                        closable: false
                    }
                }
            }
        }

        // Call to action
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            Layout.bottomMargin: Kirigami.Units.largeSpacing

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Icon {
                    source: "arrow-left"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.large
                    Layout.preferredHeight: Kirigami.Units.iconSizes.large
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.highlightColor
                    opacity: 0.6
                }

                Controls.Label {
                    text: "Select a chapter from the sidebar to begin reading"
                    font.pointSize: 12
                    font.italic: true
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.7
                }
            }
        }
    }
}
