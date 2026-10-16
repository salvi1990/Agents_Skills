---
name: backend
description: Startet den Backend-Entwickler-Agent für APIs, Geschäftslogik, Auth, Datenzugriff, Jobs und Integrationen. Aufruf mit /dev-team:backend <Aufgabe>.
argument-hint: <Aufgabe>
disable-model-invocation: true
---

Übergib die Aufgabe an den Subagent `backend-entwickler` (in der Agent-Liste ggf. als `dev-team:backend-entwickler` geführt) und lass ihn sie bearbeiten.

Aufgabe: $ARGUMENTS

1. Ist keine Aufgabe angegeben, frag kurz nach, worum es gehen soll, und starte erst danach.
2. Der Subagent startet ohne Kontext. Gib ihm die Aufgabe im Wortlaut mit, dazu alles Relevante aus dem bisherigen Gespräch: Dateipfade, Fehlermeldungen, Systemnamen, bisherige Versuche, Entscheidungen, gewünschte Sprache.
3. Gib das Ergebnis des Subagents an den Nutzer weiter, ohne es unnötig umzuschreiben. Nenne offene Punkte oder Rückfragen des Subagents ausdrücklich.
