#pragma once

#include <QAbstractListModel>
#include <QJsonObject>
#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QVector>

struct Section {
    QString section;
    QString content;
};

struct Chapter {
    QString chapter;
    QString title;
    QVector<Section> sections;
};

struct ConfessionData {
    QVariantMap metadata;
    QVector<Chapter> chapters;
};

class ConfessionModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString currentConfession READ currentConfession WRITE setCurrentConfession NOTIFY currentConfessionChanged)
    Q_PROPERTY(QVariantMap metadata READ metadata NOTIFY metadataChanged)
    Q_PROPERTY(QStringList availableConfessions READ availableConfessions CONSTANT)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum ConfessionRoles {
        ChapterNumberRole = Qt::UserRole + 1,
        ChapterTitleRole,
        SectionsRole
    };
    Q_ENUM(ConfessionRoles)

    explicit ConfessionModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString currentConfession() const;
    void setCurrentConfession(const QString &confession);
    QVariantMap metadata() const;
    QStringList availableConfessions() const;

Q_SIGNALS:
    void currentConfessionChanged();
    void metadataChanged();
    void countChanged();

private:
    bool loadConfession(const QString &filePath);

    QString m_currentConfession;
    ConfessionData m_data;
    QMap<QString, QString> m_confessionFiles;
};
