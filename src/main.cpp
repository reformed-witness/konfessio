#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QQuickStyle>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <KIconTheme>
#include "confessionmodel.h"
#include "appsettings.h"

int main(int argc, char *argv[])
{
    KIconTheme::initTheme();
    QApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("Konfessio");
    QApplication::setOrganizationName(QStringLiteral("reformedwitness"));
    QApplication::setOrganizationDomain(QStringLiteral("reformedwitness.net"));
    QApplication::setApplicationName(QStringLiteral("Konfessio"));
    QApplication::setDesktopFileName(QStringLiteral("net.reformedwitness.konfessio"));

    QApplication::setStyle(QStringLiteral("breeze"));
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }

    // Register our model types
    qmlRegisterType<ConfessionModel>("net.reformedwitness.konfessio", 1, 0, "ConfessionModel");
    qmlRegisterSingletonType<AppSettings>("net.reformedwitness.konfessio", 1, 0, "AppSettings",
        [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
            Q_UNUSED(engine)
            Q_UNUSED(scriptEngine)
            return new AppSettings();
        });

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.loadFromModule("net.reformedwitness.konfessio", "Main");

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}