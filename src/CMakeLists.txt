add_executable(konfessio)

ecm_add_qml_module(konfessio
    URI
    net.reformedwitness.konfessio
)

target_sources(konfessio
    PRIVATE
    main.cpp
    confessionmodel.h
    confessionmodel.cpp
    appsettings.h
    appsettings.cpp
    data.qrc
)

ecm_target_qml_sources(konfessio
    SOURCES
    Main.qml
    qml/components/StatCard.qml
    qml/components/InfoPage.qml
    qml/components/ChapterPage.qml
    qml/components/SettingsPage.qml
)

find_package(KF5Kirigami)

target_link_libraries(konfessio
    PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::Gui
    Qt6::QuickControls2
    Qt6::Widgets
    KF6::I18n
    KF6::CoreAddons
    KF6::IconThemes
    KF6::Kirigami
)

install(TARGETS konfessio ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
