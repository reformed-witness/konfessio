#include "appsettings.h"

using namespace Qt::StringLiterals;

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
    , m_settings(u"reformedwitness"_s, u"Konfessio"_s)
    , m_fontSize(12)
    , m_showSectionHeaders(true)
{
    loadSettings();
}

int AppSettings::fontSize() const
{
    return m_fontSize;
}

void AppSettings::setFontSize(int size)
{
    if (m_fontSize == size)
        return;

    m_fontSize = size;
    saveSettings();
    Q_EMIT fontSizeChanged();
}

bool AppSettings::showSectionHeaders() const
{
    return m_showSectionHeaders;
}

void AppSettings::setShowSectionHeaders(bool show)
{
    if (m_showSectionHeaders == show)
        return;

    m_showSectionHeaders = show;
    saveSettings();
    Q_EMIT showSectionHeadersChanged();
}

void AppSettings::reset()
{
    setFontSize(12);
    setShowSectionHeaders(true);
}

void AppSettings::loadSettings()
{
    m_fontSize = m_settings.value(u"Reading/fontSize"_s, 12).toInt();
    m_showSectionHeaders = m_settings.value(u"Reading/showSectionHeaders"_s, true).toBool();

    // Clamp font size to valid range
    if (m_fontSize < 8) m_fontSize = 8;
    if (m_fontSize > 20) m_fontSize = 20;
}

void AppSettings::saveSettings()
{
    m_settings.setValue(u"Reading/fontSize"_s, m_fontSize);
    m_settings.setValue(u"Reading/showSectionHeaders"_s, m_showSectionHeaders);
    m_settings.sync();
}
