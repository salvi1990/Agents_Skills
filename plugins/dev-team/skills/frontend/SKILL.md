---
name: frontend
description: Startet den Frontend-Entwickler-Agent für UI-Komponenten, Styling, State-Management, Barrierefreiheit und API-Anbindung. Aufruf mit /dev-team:frontend <Aufgabe>.
argument-hint: <Aufgabe>
disable-model-invocation: true
---

Übergib die Aufgabe an den Subagent `frontend-entwickler` (in der Agent-Liste ggf. als `dev-team:frontend-entwickler` geführt) und lass ihn sie bearbeiten.

Aufgabe: $ARGUMENTS

1. Ist keine Aufgabe angegeben, frag kurz nach, worum es gehen soll, und starte erst danach.
2. Der Subagent startet ohne Kontext. Gib ihm die Aufgabe im Wortlaut mit, dazu alles Relevante aus dem bisherigen Gespräch: Dateipfade, Fehlermeldungen, Systemnamen, bisherige Versuche, Entscheidungen, gewünschte Sprache.
3. Gib das Ergebnis des Subagents an den Nutzer weiter, ohne es unnötig umzuschreiben. Nenne offene Punkte oder Rückfragen des Subagents ausdrücklich.
