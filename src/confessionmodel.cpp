#include "confessionmodel.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

using namespace Qt::StringLiterals;

ConfessionModel::ConfessionModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // Map display names to file paths - try local files first for development
    QDir dataDir(u"src/data"_s);
    bool useLocalFiles = dataDir.exists();

    auto addConfession = [&](const QString &title, const QString &filename) {
        if (useLocalFiles) {
            m_confessionFiles[title] = dataDir.absoluteFilePath(filename);
        } else {
            m_confessionFiles[title] = u":/data/"_s + filename;
        }
    };

    // Biblical & Early Jewish Foundations
    addConfession(u"Shema Yisrael"_s, u"shema_yisrael.json"_s);
    addConfession(u"Confession of Peter"_s, u"confession_of_peter.json"_s);
    addConfession(u"Christian Shema"_s, u"christian_shema.json"_s);
    addConfession(u"Christ Hymn of Philippians"_s, u"christ_hymn_of_philippians.json"_s);
    addConfession(u"Christ Hymn of Colossians"_s, u"christ_hymn_of_colossians.json"_s);

    // Patristic / Early Church
    addConfession(u"Ignatius' Creed"_s, u"ignatius_creed.json"_s);
    addConfession(u"Irenaeus' Rule of Faith"_s, u"irenaeus_rule_of_faith.json"_s);
    addConfession(u"Tertullian's Rule of Faith"_s, u"tertullians_rule_of_faith.json"_s);
    addConfession(u"Gregory's Declaration of Faith"_s, u"gregorys_declaration_of_faith.json"_s);
    addConfession(u"Nicene Creed"_s, u"nicene_creed.json"_s);
    addConfession(u"Chalcedonian Definition"_s, u"chalcedonian_definition.json"_s);
    addConfession(u"Council of Orange"_s, u"council_of_orange.json"_s);
    addConfession(u"Apostles' Creed"_s, u"apostles_creed.json"_s);
    addConfession(u"Athanasian Creed"_s, u"athanasian_creed.json"_s);
    addConfession(u"Waldensian Confession"_s, u"waldensian_confession.json"_s);

    // Reformed
    addConfession(u"Zwingli's 67 Articles"_s, u"zwinglis_67_articles.json"_s);
    addConfession(u"Ten Theses of Berne"_s, u"ten_theses_of_berne.json"_s);
    addConfession(u"Tetrapolitan Confession"_s, u"tetrapolitan_confession.json"_s);
    addConfession(u"Zwingli's Fidei Ratio"_s, u"zwinglis_fidei_ratio.json"_s);
    addConfession(u"First Confession of Basel"_s, u"first_confession_of_basel.json"_s);
    addConfession(u"First Helvetic Confession"_s, u"first_helvetic_confession.json"_s);
    addConfession(u"Consensus Tigurinus"_s, u"consensus_tigurinus.json"_s);
    addConfession(u"French Confession of Faith"_s, u"french_confession_of_faith.json"_s);
    addConfession(u"Scots Confession"_s, u"scots_confession.json"_s);
    addConfession(u"Belgic Confession"_s, u"belgic_confession_of_faith.json"_s);
    addConfession(u"Second Helvetic Confession"_s, u"second_helvetic_confession.json"_s);
    addConfession(u"Heidelberg Catechism"_s, u"heidelberg_catechism.json"_s);
    addConfession(u"Canons of Dort"_s, u"canons_of_dort.json"_s);
    addConfession(u"Helvetic Consensus"_s, u"helvetic_consensus.json"_s);

    // Puritan / Westminster (British Reformed)
    addConfession(u"Westminster Confession of Faith"_s, u"westminster_confession_of_faith.json"_s);
    addConfession(u"Westminster Larger Catechism"_s, u"westminster_larger_catechism.json"_s);
    addConfession(u"Westminster Shorter Catechism"_s, u"westminster_shorter_catechism.json"_s);
    addConfession(u"Savoy Declaration of Faith"_s, u"savoy_declaration.json"_s);
    addConfession(u"An Exposition of the Assemblies Catechism"_s, u"exposition_of_the_assemblies_catechism.json"_s);
    addConfession(u"Matthew Henry's Scripture Catechism"_s, u"matthew_henrys_scripture_catechism.json"_s);
    addConfession(u"The Assembly's Shorter Catechism Explained"_s, u"shorter_catechism_explained.json"_s);

    // Baptist
    addConfession(u"1689 London Baptist Confession"_s, u"london_baptist_1689.json"_s);
    addConfession(u"1695 Baptist Catechism"_s, u"1695_baptist_catechism.json"_s);
    addConfession(u"Keach's Catechism"_s, u"keachs_catechism.json"_s);
    addConfession(u"Abstract of Principles"_s, u"abstract_of_principles.json"_s);
    addConfession(u"Catechism For Young Children"_s, u"catechism_for_young_children.json"_s);
    addConfession(u"Puritan Catechism"_s, u"puritan_catechism.json"_s);

    // Modern Evangelical
    addConfession(u"Chicago Statement on Biblical Inerrancy"_s, u"chicago_statement_on_biblical_inerrancy.json"_s);

    // Load first confession by default
    if (!m_confessionFiles.isEmpty()) {
        setCurrentConfession(m_confessionFiles.firstKey());
    }
}

int ConfessionModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.chapters.count();
}

QVariant ConfessionModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.chapters.count())
        return QVariant();

    const Chapter &chapter = m_data.chapters.at(index.row());

    switch (role) {
    case ChapterNumberRole:
        return chapter.chapter;
    case ChapterTitleRole:
        return chapter.title;
    case SectionsRole: {
        QVariantList sectionsList;
        for (const Section &section : chapter.sections) {
            QVariantMap sectionMap;
            sectionMap[u"section"_s] = section.section;
            sectionMap[u"content"_s] = section.content;
            sectionsList.append(sectionMap);
        }
        return sectionsList;
    }
    }

    return QVariant();
}

QHash<int, QByteArray> ConfessionModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ChapterNumberRole] = "chapterNumber";
    roles[ChapterTitleRole] = "chapterTitle";
    roles[SectionsRole] = "sections";
    return roles;
}

QString ConfessionModel::currentConfession() const
{
    return m_currentConfession;
}

void ConfessionModel::setCurrentConfession(const QString &confession)
{
    if (m_currentConfession == confession)
        return;

    if (!m_confessionFiles.contains(confession)) {
        qWarning() << "Unknown confession:" << confession;
        return;
    }

    QString filePath = m_confessionFiles[confession];
    if (loadConfession(filePath)) {
        m_currentConfession = confession;
        Q_EMIT currentConfessionChanged();
    }
}

QVariantMap ConfessionModel::metadata() const
{
    return m_data.metadata;
}

QStringList ConfessionModel::availableConfessions() const
{
    return m_confessionFiles.keys();
}

bool ConfessionModel::loadConfession(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open file:" << filePath << file.errorString();
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qWarning() << "Invalid JSON in file:" << filePath;
        return false;
    }

    QJsonObject root = doc.object();

    beginResetModel();
    m_data.chapters.clear();

    // Parse metadata
    QJsonObject metadataObj = root[u"Metadata"_s].toObject();
    m_data.metadata.clear();
    m_data.metadata[u"title"_s] = metadataObj[u"Title"_s].toString();
    m_data.metadata[u"year"_s] = metadataObj[u"Year"_s].toString();
    m_data.metadata[u"location"_s] = metadataObj[u"Location"_s].toString();
    m_data.metadata[u"originalLanguage"_s] = metadataObj[u"OriginalLanguage"_s].toString();
    m_data.metadata[u"creedFormat"_s] = metadataObj[u"CreedFormat"_s].toString();

    QJsonArray authorsArray = metadataObj[u"Authors"_s].toArray();
    QStringList authorsList;
    for (const QJsonValue &author : authorsArray) {
        authorsList.append(author.toString());
    }
    m_data.metadata[u"authors"_s] = authorsList;

    // Parse chapters - handle different JSON structures
    QJsonValue dataValue = root[u"Data"_s];

    if (dataValue.isArray()) {
        QJsonArray dataArray = dataValue.toArray();

        for (int i = 0; i < dataArray.size(); ++i) {
            QJsonObject item = dataArray.at(i).toObject();
            Chapter chapter;

            // Check if this is a catechism format (Question/Answer)
            if (item.contains(u"Question"_s)) {
                // Catechism format: Number, Question, Answer
                chapter.chapter = item[u"Number"_s].toVariant().toString();
                chapter.title = item[u"Question"_s].toString();

                Section section;
                section.section = u"1"_s;
                section.content = item[u"Answer"_s].toString();
                chapter.sections.append(section);
            }
            // Check if this is a chapter/section format
            else if (item.contains(u"Sections"_s)) {
                chapter.chapter = item[u"Chapter"_s].toString();
                chapter.title = item[u"Title"_s].toString();

                QJsonArray sections = item[u"Sections"_s].toArray();
                for (const QJsonValue &sectionValue : sections) {
                    QJsonObject sectionObj = sectionValue.toObject();

                    Section section;
                    section.section = sectionObj[u"Section"_s].toString();
                    section.content = sectionObj[u"Content"_s].toString();

                    chapter.sections.append(section);
                }
            }
            // Fallback for simple chapter format
            else {
                chapter.chapter = item[u"Chapter"_s].toString();
                chapter.title = item[u"Title"_s].toString();

                // Create a single section with content if available
                if (item.contains(u"Content"_s)) {
                    Section section;
                    section.section = u"1"_s;
                    section.content = item[u"Content"_s].toString();
                    chapter.sections.append(section);
                }
            }

            m_data.chapters.append(chapter);
        }
    }
    // Handle simple creed format where Data is just an object with Content
    else if (dataValue.isObject()) {
        QJsonObject dataObj = dataValue.toObject();
        Chapter chapter;
        chapter.chapter = u"1"_s;
        chapter.title = m_data.metadata[u"title"_s].toString();

        Section section;
        section.section = u"1"_s;
        section.content = dataObj[u"Content"_s].toString();
        chapter.sections.append(section);

        m_data.chapters.append(chapter);
    }

    endResetModel();
    Q_EMIT metadataChanged();
    Q_EMIT countChanged();

    return true;
}
