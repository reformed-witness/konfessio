#pragma once

#include <QObject>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(bool showSectionHeaders READ showSectionHeaders WRITE setShowSectionHeaders NOTIFY showSectionHeadersChanged)

public:
    explicit AppSettings(QObject *parent = nullptr);

    int fontSize() const;
    void setFontSize(int size);

    bool showSectionHeaders() const;
    void setShowSectionHeaders(bool show);

    Q_INVOKABLE void reset();

Q_SIGNALS:
    void fontSizeChanged();
    void showSectionHeadersChanged();

private:
    QSettings m_settings;
    int m_fontSize;
    bool m_showSectionHeaders;

    void loadSettings();
    void saveSettings();
};
