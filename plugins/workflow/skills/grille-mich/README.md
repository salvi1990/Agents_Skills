# grille-mich

Autor: Matt Pocock (Original, MIT-Lizenz). Deutsche Fassung: Jonas Keil, jonaskeil.com
Deutsche Fassung des Skills `grill-me` (Original: https://github.com/mattpocock/skills).

Quelle: https://github.com/mattpocock/skills (Commit 6654f6b, Stand 24.08.2026, MIT-Lizenz)

Im Original ist `grill-me` nur ein Einzeiler, der den Skill `grilling` aufruft. Diese Fassung führt beide zusammen, damit sie ohne weitere Abhängigkeiten funktioniert:

- `skills/productivity/grill-me/SKILL.md` (Frontmatter, nur per Nutzeraufruf)
- `skills/productivity/grilling/SKILL.md` (das eigentliche Interview in Runden)

## Was der Skill macht

Nimmt eine lose Idee (Feature, Produktrichtung, Business-Entscheidung, Text) und interviewt dich Runde für Runde, bis du dich festlegen kannst. Jede Runde enthält die komplette "Front": alle Fragen, deren Voraussetzungen schon geklärt sind. Der Skill schreibt keine Dateien und hinterlässt nichts außer einer schärferen Version deiner Idee.

## Aufruf

In Claude Code: `/workflow:grille-mich` gefolgt von deiner Idee. Am besten in einer frischen Konversation, ohne Plan-Modus.

## Tipps aus der Original-Doku

- Du bestimmst den Umfang. Widersprich, wenn eine Frage zu grob ist, sag "weiß ich nicht", wenn es so ist. Eine Sitzung ohne Widerspruch von dir war eine Sitzung, die du nicht gebraucht hast.
- Manche Fragen sind "nicht grillbar" ("eine lange Seite oder drei?"). Dann aufhören, einen Wegwerf-Prototyp bauen, anschauen, in einem Satz beantworten.
- Zu viele Fragen (200+)? Der Umfang war zu groß. Erst in kleinere Teile zerlegen, dann jedes Teil grillen.
- Eine Frage nach der anderen statt in Runden? Diese Zeile in die globale `CLAUDE.md`: `Beim Grillen immer nur eine Frage auf einmal stellen.`

## Installation

In diesem Repository Teil des Plugins `workflow` (siehe README im Repo-Root). Die Codex-Datei `agents/openai.yaml` aus dem Original-Paket ist für Claude Code nicht nötig und wurde weggelassen.

Anpassungen gegenüber der Vorlage: `argument-hint` ergänzt und ein Einstieg, der nach dem Thema fragt, wenn `/workflow:grille-mich` ohne Text aufgerufen wird.

## Lizenz und Weitergabe

Das Original steht unter MIT-Lizenz (Copyright Matt Pocock). Diese deutsche Fassung darf frei weitergegeben werden, solange der Hinweis auf Quelle und Lizenz erhalten bleibt.
