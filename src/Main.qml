import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import net.reformedwitness.konfessio

Kirigami.ApplicationWindow {
    id: root
    title: "Konfessio"

    width: 1200
    height: 800

    property int currentChapterIndex: -1

    // Layout constants for responsive content max-width
    readonly property int contentMaxWidthNarrow: Kirigami.Units.gridUnit * 50  // ~800px
    readonly property int contentMaxWidthWide: Kirigami.Units.gridUnit * 56    // ~900px

    // Data model
    ConfessionModel {
        id: confessionModel
    }

    Component.onCompleted: {
        pageStack.push(infoPageComponent, { "confessionModel": confessionModel })
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: StandardKey.Find
        onActivated: {
            if (root.globalDrawer) {
                root.globalDrawer.open()
                chapterSearch.forceActiveFocus()
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+/"
        onActivated: {
            if (root.globalDrawer) {
                root.globalDrawer.open()
                confessionSearch.forceActiveFocus()
            }
        }
    }

    Shortcut {
        sequence: "Alt+Left"
        onActivated: {
            if (root.currentChapterIndex > 0) {
                navigateToPreviousChapter()
            }
        }
    }

    Shortcut {
        sequence: "Alt+Right"
        onActivated: {
            if (root.currentChapterIndex < confessionModel.count - 1) {
                navigateToNextChapter()
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+H"
        onActivated: {
            root.currentChapterIndex = -1
            root.pageStack.clear()
            root.pageStack.push(infoPageComponent, {
                "confessionModel": confessionModel
            })
        }
    }

    Shortcut {
        sequence: StandardKey.Preferences
        onActivated: {
            openSettingsPage()
        }
    }

    function openSettingsPage() {
        // Check if settings page is already open
        for (let i = 0; i < root.pageStack.depth; i++) {
            let page = root.pageStack.get(i)
            if (page && page.title === "Settings") {
                // Settings already open, just pop to it
                while (root.pageStack.depth > i + 1) {
                    root.pageStack.pop()
                }
                return
            }
        }
        // Settings not open, push it
        root.pageStack.push(settingsPageComponent)
    }

    function navigateToPreviousChapter() {
        if (currentChapterIndex > 0) {
            var prevIndex = currentChapterIndex - 1
            var prevChapter = confessionModel.data(confessionModel.index(prevIndex, 0), ConfessionModel.ChapterNumberRole)
            var prevTitle = confessionModel.data(confessionModel.index(prevIndex, 0), ConfessionModel.ChapterTitleRole)
            var prevSections = confessionModel.data(confessionModel.index(prevIndex, 0), ConfessionModel.SectionsRole)

            currentChapterIndex = prevIndex
            pageStack.replace(chapterPageComponent, {
                "confessionModel": confessionModel,
                "chapterIndex": prevIndex,
                "chapterNum": prevChapter,
                "chapterTitle": prevTitle,
                "sections": prevSections
            })
        }
    }

    function navigateToNextChapter() {
        if (currentChapterIndex < confessionModel.count - 1) {
            var nextIndex = currentChapterIndex + 1
            var nextChapter = confessionModel.data(confessionModel.index(nextIndex, 0), ConfessionModel.ChapterNumberRole)
            var nextTitle = confessionModel.data(confessionModel.index(nextIndex, 0), ConfessionModel.ChapterTitleRole)
            var nextSections = confessionModel.data(confessionModel.index(nextIndex, 0), ConfessionModel.SectionsRole)

            currentChapterIndex = nextIndex
            pageStack.replace(chapterPageComponent, {
                "confessionModel": confessionModel,
                "chapterIndex": nextIndex,
                "chapterNum": nextChapter,
                "chapterTitle": nextTitle,
                "sections": nextSections
            })
        }
    }



    // Leftmost Sidebar (Confession selector + Chapter list)
    globalDrawer: Kirigami.OverlayDrawer {
        edge: Qt.LeftEdge
        modal: root.width < Kirigami.Units.gridUnit * 60  // ~960px breakpoint
        width: {
            if (root.width < Kirigami.Units.gridUnit * 40) {
                // Mobile: Full width minus margin
                return Math.min(root.width - Kirigami.Units.gridUnit * 2, 320)
            } else if (root.width < Kirigami.Units.gridUnit * 60) {
                // Tablet: 40% of screen
                return Math.min(root.width * 0.4, 400)
            } else {
                // Desktop: Fixed comfortable width
                return 320
            }
        }

        onModalChanged: {
            if (!modal && root.currentChapterIndex >= 0) {
                // On desktop, keep drawer open
                open()
            }
        }

        contentItem: ColumnLayout {
            spacing: 0
            anchors.fill: parent

            // Header with confession selector
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.largeSpacing
                Layout.rightMargin: Kirigami.Units.largeSpacing
                Layout.topMargin: Kirigami.Units.largeSpacing
                Layout.bottomMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Heading {
                    text: "Confessions"
                    level: 2
                }

                Kirigami.SearchField {
                    id: confessionSearch
                    Layout.fillWidth: true
                    placeholderText: "Search confessions..."
                    onTextChanged: {
                        confessionSelector.currentIndex = -1
                        for (let i = 0; i < confessionModel.availableConfessions.length; i++) {
                            if (confessionModel.availableConfessions[i].toLowerCase().includes(text.toLowerCase())) {
                                confessionSelector.currentIndex = i
                                break
                            }
                        }
                    }
                }

                Controls.ComboBox {
                    id: confessionSelector
                    Layout.fillWidth: true
                    model: confessionModel.availableConfessions
                    currentIndex: 0
                    onCurrentTextChanged: {
                        if (currentText) {
                            confessionModel.currentConfession = currentText
                            root.currentChapterIndex = -1
                            chapterSearch.text = ""
                            root.pageStack.clear()
                            root.pageStack.push(infoPageComponent, {
                                "confessionModel": confessionModel
                            })
                        }
                    }
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
            }

            // Chapters section
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.largeSpacing
                Layout.rightMargin: Kirigami.Units.largeSpacing
                Layout.topMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.largeSpacing

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        text: "Chapters"
                        level: 3
                        Layout.fillWidth: true
                    }

                    Controls.Label {
                        text: {
                            if (chapterSearch.text === "") {
                                return confessionModel.count
                            } else {
                                var visibleCount = 0
                                for (var i = 0; i < confessionModel.count; i++) {
                                    var chapterNum = confessionModel.data(
                                        confessionModel.index(i, 0),
                                        ConfessionModel.ChapterNumberRole
                                    )
                                    var chapterTitle = confessionModel.data(
                                        confessionModel.index(i, 0),
                                        ConfessionModel.ChapterTitleRole
                                    )
                                    if (chapterTitle.toLowerCase().includes(chapterSearch.text.toLowerCase()) ||
                                        chapterNum.toLowerCase().includes(chapterSearch.text.toLowerCase())) {
                                        visibleCount++
                                    }
                                }
                                return visibleCount + " / " + confessionModel.count
                            }
                        }
                        opacity: 0.7
                        font.pointSize: 9
                    }
                }

                Kirigami.SearchField {
                    id: chapterSearch
                    Layout.fillWidth: true
                    placeholderText: "Filter chapters..."
                }
            }

            // Chapter list
            ListView {
                id: chapterListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: confessionModel
                clip: true
                currentIndex: root.currentChapterIndex

                section.property: "chapterNumber"
                section.criteria: ViewSection.FirstCharacter

                delegate: Controls.ItemDelegate {
                    width: ListView.view.width
                    visible: chapterSearch.text === "" ||
                             chapterTitle.toLowerCase().includes(chapterSearch.text.toLowerCase()) ||
                             chapterNumber.toLowerCase().includes(chapterSearch.text.toLowerCase())
                    height: visible ? implicitHeight : 0
                    highlighted: root.currentChapterIndex === index
                    hoverEnabled: true
                    leftPadding: Kirigami.Units.largeSpacing
                    rightPadding: Kirigami.Units.largeSpacing
                    topPadding: Kirigami.Units.smallSpacing
                    bottomPadding: Kirigami.Units.smallSpacing

                    background: Rectangle {
                        color: {
                            if (root.currentChapterIndex === index) {
                                return Qt.rgba(Kirigami.Theme.highlightColor.r,
                                              Kirigami.Theme.highlightColor.g,
                                              Kirigami.Theme.highlightColor.b, 0.3)
                            } else if (parent.pressed) {
                                return Qt.rgba(Kirigami.Theme.highlightColor.r,
                                              Kirigami.Theme.highlightColor.g,
                                              Kirigami.Theme.highlightColor.b, 0.2)
                            } else if (parent.hovered) {
                                return Qt.rgba(Kirigami.Theme.highlightColor.r,
                                              Kirigami.Theme.highlightColor.g,
                                              Kirigami.Theme.highlightColor.b, 0.1)
                            } else {
                                return "transparent"
                            }
                        }
                        radius: Kirigami.Units.smallSpacing
                    }

                    contentItem: RowLayout {
                        spacing: Kirigami.Units.largeSpacing

                        Rectangle {
                            Layout.preferredWidth: 4
                            Layout.preferredHeight: Kirigami.Units.largeSpacing * 2
                            radius: 2
                            color: Kirigami.Theme.highlightColor
                            visible: root.currentChapterIndex === index
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing / 2

                            Controls.Label {
                                text: chapterNumber
                                font.bold: true
                                font.pointSize: root.currentChapterIndex === index ? 10 : 9
                                opacity: root.currentChapterIndex === index ? 1.0 : 0.7
                                color: root.currentChapterIndex === index ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
                            }

                            Controls.Label {
                                Layout.fillWidth: true
                                text: chapterTitle
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                font.pointSize: root.currentChapterIndex === index ? 11 : 10
                                font.weight: root.currentChapterIndex === index ? Font.DemiBold : Font.Normal
                                color: root.currentChapterIndex === index ? Kirigami.Theme.textColor : Kirigami.Theme.textColor
                            }
                        }
                    }

                    onClicked: {
                        root.currentChapterIndex = index
                        root.pageStack.clear()
                        root.pageStack.push(chapterPageComponent, {
                            "confessionModel": confessionModel,
                            "chapterIndex": index,
                            "chapterNum": chapterNumber,
                            "chapterTitle": chapterTitle,
                            "sections": sections
                        })

                        // Auto-close drawer on mobile
                        if (root.globalDrawer && root.globalDrawer.modal) {
                            root.globalDrawer.close()
                        }
                    }
                }
            }

            // Settings button at bottom
            Kirigami.Separator {
                Layout.fillWidth: true
            }

            Controls.ItemDelegate {
                Layout.fillWidth: true
                Layout.margins: Kirigami.Units.largeSpacing
                icon.name: "settings-configure"
                text: "Settings"
                hoverEnabled: true

                background: Rectangle {
                    color: {
                        if (parent.pressed) {
                            return Qt.rgba(Kirigami.Theme.highlightColor.r,
                                          Kirigami.Theme.highlightColor.g,
                                          Kirigami.Theme.highlightColor.b, 0.2)
                        } else if (parent.hovered) {
                            return Qt.rgba(Kirigami.Theme.highlightColor.r,
                                          Kirigami.Theme.highlightColor.g,
                                          Kirigami.Theme.highlightColor.b, 0.1)
                        } else {
                            return "transparent"
                        }
                    }
                    radius: Kirigami.Units.smallSpacing
                }

                onClicked: {
                    root.openSettingsPage()
                }
            }
        }
    }

    // Main Content Area - Start with info page
    Component {
        id: infoPageComponent
        InfoPage {
            confessionModel: root.confessionModel
        }
    }

    Component {
        id: chapterPageComponent
        ChapterPage {
            confessionModel: root.confessionModel

            onNavigateToPrevious: {
                root.navigateToPreviousChapter()
            }
            onNavigateToNext: {
                root.navigateToNextChapter()
            }
        }
    }

    Component {
        id: settingsPageComponent
        SettingsPage {
            fontSize: AppSettings.fontSize
            showSectionHeaders: AppSettings.showSectionHeaders

            onSettingsChanged: {
                AppSettings.fontSize = fontSize
                AppSettings.showSectionHeaders = showSectionHeaders
            }
        }
    }
}