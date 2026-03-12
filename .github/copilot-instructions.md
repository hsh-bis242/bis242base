# Copilot-Anweisungen für den BIS242-Workspace

Dieser Workspace enthält zwei zusammengehörige Repositories mit unterschiedlichen Rollen innerhalb der Lehrveranstaltung BIS242. Copilot soll Änderungen immer im Kontext des jeweils betroffenen Repositories vornehmen und den Zweck der beiden Projekte sauber voneinander trennen.

## Überblick über die Repositories

### `bis242base`
- Zweck: Basis-Repository für den praktischen Teil von BIS242.
- Haupttechnologie: `dbt` mit SQL-Modellen, Makros, Seeds, Snapshots, Tests und generierten Artefakten.
- Typische Nutzung: Aufbau und Erweiterung von ELT- und Data-Vault-nahen Transformationsstrecken für die Kursdaten.

### `hsh-bi-class`
- Zweck: Repository für Vorlesungsunterlagen und Foliensätze.
- Haupttechnologie: statische HTML-Folien auf Basis von `reveal.js` sowie CSS, JavaScript und statischen Assets.
- Typische Nutzung: Pflege von Vorlesungsdecks, Präsentationslayout und Veröffentlichungslogik der Kurswebsite.

## GitHub Classroom und Gruppenstruktur

- Die Lehrveranstaltung nutzt **GitHub Classroom** zur Verwaltung der Gruppenrepositories.
- Classroom-Name: `bis-242`
- Aktuelles Assignment: `bis-242-ss26` (Sommersemester 2026)
- Einladungslink (SS26): <https://classroom.github.com/a/g8uBDJZ8>
- Es gibt max. 10 Teams (`gruppe01` bis `gruppe10`) mit jeweils max. 3 Teilnehmern.
- Jedes Team erhält ein eigenes Repository (z. B. `hsh-bis242/bis-242-ss26-gruppe02`), das aus `bis242base` als Template erzeugt wird.
- Der Einladungslink ändert sich jedes Semester, wenn ein neues Assignment erstellt wird.
- `bis242base` dient als Template-Repository und wird nicht direkt von Studierenden bearbeitet.

## Databricks Workspace

- Aktuelle Workspace-URL: <https://dbc-15d76289-5b7c.cloud.databricks.com/>
- Zum Semesterwechsel muss ein neuer Databricks-Community-Workspace erstellt werden.
- Die Workspace-URL muss anschließend in `U01_InfrastrukturZugang.html` und in diesen Instructions aktualisiert werden.

## Checkliste Semesterwechsel

Folgende Schritte sind zu Beginn jedes neuen Semesters erforderlich:

1. **Neuen Databricks Workspace erstellen** und URL in `U01_InfrastrukturZugang.html` sowie in den Copilot-Instructions aktualisieren.
2. **Neues GitHub Classroom Assignment erstellen** (z. B. `bis-242-ws26`) und den Einladungslink in `U01_InfrastrukturZugang.html` sowie in den Copilot-Instructions aktualisieren.
3. **Neuen QR-Code für die Vorkenntnisse-Umfrage** generieren und in `static/U01/QR_Code_Umfrage.png` ersetzen.
4. **Moodle-Gruppen** anlegen bzw. zurücksetzen und den Link in `U01_InfrastrukturZugang.html` prüfen.
5. **Semesterbezeichnungen** in den Übungsfolien aktualisieren (z. B. `242ss` → `242ws` oder umgekehrt).
6. **`V01_OrganisatorischeVorbemerkungen.html`** auf aktuelle Termine und organisatorische Hinweise prüfen.
7. **Neue Gruppen-Datei** in `gruppen/` anlegen (z. B. `ws26.md`) und Gruppenzuordnungen pflegen.

## Aufbau von `bis242base`

Das Repository bündelt allgemeine Kursmaterialien sowie zwei eigenständige dbt-Projekte.

### Top-Level-Struktur
- `README.md`: allgemeine Beschreibung des Repositories sowie Setup-Hinweise.
- `requirements.txt`: Python-Abhängigkeiten für das lokale dbt-Umfeld.
- `wanderbricks/`: dbt-Projekt für das Wanderbricks-Beispiel.
- `willibald_dwh/`: dbt-Projekt für das Willibald-Data-Warehouse-Beispiel.

### Typischer Aufbau der dbt-Projekte in `wanderbricks/` und `willibald_dwh/`
- `dbt_project.yml`, `profiles.yml`, `packages.yml`: Projekt- und Paketkonfiguration.
- `models/`: dbt-Modelle, typischerweise nach Schichten organisiert, etwa Quellen, Staging, Integration und Marts.
- `macros/`: wiederverwendbare SQL-Generierungslogik, insbesondere für Data-Vault-Muster wie Hubs, Links, Satelliten, LSATs, Hash-Spalten und Hilfslogik.
- `seeds/`: statische Eingabedaten, z. B. persistierte Staging-Daten oder Beispieldaten.
- `snapshots/`: Historisierung über dbt-Snapshots.
- `tests/`: fachliche oder technische Tests.
- `analyses/`: ad-hoc-Analysen in SQL.
- `backup/`: Referenzstände oder archivierte Modellvarianten.
- `logs/` und `target/`: generierte Artefakte; diese gelten als abgeleitete Ausgabe und sollen normalerweise nicht manuell bearbeitet werden.
- `dbt_packages/`: installierte dbt-Abhängigkeiten.

### Arbeitsregeln für Copilot in `bis242base`
- Bevorzuge Änderungen in `models/`, `macros/`, `seeds/`, `snapshots/` und `tests/` statt in generierten Verzeichnissen.
- Nutze vorhandene Makros wieder, bevor neue Data-Vault-Ladelogik eingeführt wird.
- Halte Benennungen, Schichtlogik und Struktur konsistent mit dem bestehenden dbt-Projekt.
- Ändere `target/`, `logs/` und `dbt_packages/` nur, wenn dies ausdrücklich verlangt wird.
- Bevorzuge kleine, gezielte Änderungen an bestehenden Modellen gegenüber breitflächigen Umstrukturierungen.
- Wenn eine Aufgabe fachliche Logik betrifft, ändere bevorzugt die eigentliche Transformationslogik statt nur Symptome in Folgeartefakten zu kaschieren.

## Aufbau von `hsh-bi-class`

Dieses Repository enthält die Lehrmaterialien als webbasierte Foliensätze.

### Top-Level-Struktur
- `index.html`: Einstiegsseite für die Kursmaterialien.
- `README.md`: Zweck des Repositories und Hinweise zur Pflege.
- `custom.css`: globale projektspezifische Styles.
- `gulpfile.js`, `package.json`: Frontend-Tooling und Build-Unterstützung.
- `*.html`: einzelne Vorlesungs- oder Übungseinheiten als eigenständige Foliendecks.
- `gruppen/`: Übungsgruppen-Verwaltung mit je einer Markdown-Datei pro Semester (z. B. `ss26.md`). Enthält Gruppenzuordnungen (E-Mails) und Teilnehmer ohne Gruppe.
- `.github/workflows/`: Automatisierung für Deployment und Veröffentlichung.

### Frontend-Struktur
- `css/`: Layout-, Theme- und Druck-Styles.
- `js/`: Reveal-Konfiguration sowie unterstützende JavaScript-Logik.
- `plugin/`: Reveal-Plugins, z. B. für Markdown, Math, Notes, Search, Zoom und Syntax-Highlighting.
- `static/`: Bilder, Logos, Diagramme und weitere statische Assets.

### Benennungskonventionen der HTML-Dateien
- `U01_*.html`, `U02_*.html`, … sind **Übungseinheiten**. Sie beziehen sich direkt auf das dbt-Projekt in `bis242base` und setzen einen Databricks-Free-Workspace voraus.
- `V01_*.html`, `V02_*.html`, … sind **Vorlesungsfolien** mit theoretischen und konzeptionellen Inhalten.

### Arbeitsregeln für Copilot in `hsh-bi-class`
- Behandle jede Top-Level-HTML-Datei als eigenständiges Foliendeck.
- Halte HTML-Markup kompatibel zu den im Repository bereits verwendeten `reveal.js`-Konventionen.
- Lege wiederverwendbare Styles bevorzugt in `custom.css` oder passenden Dateien unter `css/` ab.
- Lege Assets in `static/` ab und verwende stabile relative Pfade.
- Sei vorsichtig bei Änderungen unter `.github/workflows/`, da diese die Veröffentlichung der Kurswebsite steuern.
- Bevorzuge konsistente, minimalinvasive Layout-Änderungen statt unnötiger struktureller Umbauten an kompletten Foliensätzen.

## Zusammenhang der beiden Repositories

- `hsh-bi-class` dokumentiert und erläutert die Konzepte, die in `bis242base` praktisch umgesetzt werden.
- `bis242base` ist transformations- und codeorientiert.
- `hsh-bi-class` ist inhalts-, didaktik- und präsentationsorientiert.
- Bei Änderungen soll Copilot den Charakter des jeweiligen Repositories respektieren und keine Präsentationslogik mit dbt-Implementierungslogik vermischen.
- **Wichtig:** Wenn Änderungen an einer Übung (`U*`-HTML in `hsh-bi-class`) oder am dbt-Projekt (`bis242base`) vorgenommen werden, prüfe immer, ob im jeweils anderen Repository ebenfalls Anpassungen nötig sind, damit Code und Anleitung konsistent bleiben.

## Allgemeine Copilot-Arbeitsregeln für diesen Workspace

- Nimm standardmäßig minimale, zielgerichtete Änderungen vor.
- Bewahre die bestehende Struktur, Benennung und den Stil des jeweils betroffenen Repositories.
- Bearbeite bevorzugt Quellartefakte und nicht generierte Ausgaben.
- Fasse Änderungen logisch zusammen und vermeide unnötige Nebenänderungen.
- Aktualisiere Dokumentation, wenn Struktur, Workflow oder Nutzung sichtbar beeinflusst werden.
- Wenn mehrere Lösungswege möglich sind, bevorzuge die Variante, die sich am besten in die vorhandene Codebasis einfügt.
- Erzeuge keine neuen Frameworks, Build-Systeme oder großflächigen Refactorings ohne klaren Bedarf.
- Prüfe bei Aufgaben immer zuerst, zu welchem Repository die Änderung fachlich gehört.
- Wenn Dateien in beiden Repositories ähnlich heißen oder ähnliche Themen behandeln, entscheide anhand des Repository-Zwecks und nicht nur anhand des Dateinamens.
- Erkläre Änderungen kurz und präzise, mit Fokus auf Auswirkung, betroffene Dateien und sinnvolle nächste Schritte.