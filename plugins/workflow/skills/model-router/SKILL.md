---
name: model-router
description: Use for every request when the user has asked Claude to always pick the model itself, says "wähl das Modell selbst", or invokes /workflow:model-router. Routes to Sonnet, Opus or (rarely) Fable and delegates.
---

# Model Router

Ziel: Anfrage kurz einschätzen, passendes Modell wählen, mit diesem Modell antworten lassen. Die Einschätzung dauert Sekunden, nicht die halbe Antwort.

Erlaubt sind nur **Sonnet**, **Opus** und **Fable**. Haiku wird nie verwendet.

## 1. Anfrage einstufen

**Sonnet** – Standard, im Zweifel diese Stufe
- Kurze Fragen, Syntax, Rechtschreibung, Umformulieren, Formatieren
- Skripte schreiben oder anpassen (PowerShell, T-SQL, PL/SQL, Bash, Python)
- Troubleshooting mit klarer Fehlermeldung
- Erklärungen, Runbooks, Doku in Markdown
- E-Mails und Texte
- Normale Code-Reviews

**Opus**
- Diagnose mit unklarer Ursache über mehrere Komponenten (z.B. Data Guard Lag, AG-Failover-Probleme, Performance-Einbrüche mit mehreren Verdächtigen)
- Architektur, Migrationsplanung (z.B. Oracle → MariaDB), HA- oder Kapazitätsdesign
- Änderungen an Produktion mit hohem Risiko
- Lange Dokumente oder Logs, die zusammenhängend ausgewertet werden müssen
- Grössere Codebasis anpassen oder refactoren
- Ein Sonnet-Versuch im selben Chat hat nicht gereicht

**Fable** – nur in wenigen, wirklich komplizierten Fällen
Nur wenn mindestens zwei davon zutreffen:
- Sehr lange, mehrstufige Aufgabe über viele Systeme oder Dateien
- Opus hat es im selben Chat schon versucht und ist gescheitert
- Hohe Tragweite und keine bekannte Standardlösung
- Ausdrücklich gewünscht ("nimm das stärkste Modell") – das allein reicht auch

Hochstufen um eine Stufe, wenn Produktion betroffen und die Anfrage mehrdeutig ist.

## 2. Ausführen

### Wenn ein Agent-/Task-Tool mit `model`-Parameter verfügbar ist
- Gewähltes Modell = aktuelles Modell → selbst direkt antworten.
- Sonst → Subagent mit `model: sonnet | opus | fable` starten.
  - Der Subagent startet ohne Kontext. Gib ihm die Anfrage im Wortlaut plus alles Relevante aus dem Chat mit: Fehlermeldungen, Dateipfade, Systemnamen, bisherige Versuche, gewünschte Sprache und Stil.
  - Ergebnis weitergeben, nicht unnötig umschreiben.
- Ist das aktuelle Modell stärker als nötig und die Aufgabe kurz, direkt antworten statt delegieren (spart Zeit, Ergebnis ist gleich gut).

### Wenn kein solches Tool verfügbar ist
Das Modell lässt sich nur im Modellwähler umstellen. Dann:
- Empfohlenes Modell ≤ aktuelles → einfach antworten.
- Empfohlenes Modell > aktuelles → eine Zeile oben: "Tipp: Dafür wäre Opus besser, Modellwähler oben." Danach trotzdem so gut wie möglich antworten.

## 3. Ausgabe

- Gewähltes Modell in einer Zeile nennen, z.B. `→ Opus (Diagnose über mehrere Komponenten)`.
- Danach die eigentliche Antwort, in Sprache und Stil des Nutzers.

## Als Hauptagent in Claude Code

Dieses Plugin enthält zusätzlich den Agent `model-router` (`plugins/workflow/agents/model-router.md`). Als Hauptagent gestartet stuft er jede Anfrage ein und delegiert wie oben; selbst antwortet er nur bei Sonnet-Aufgaben:

```bash
claude --agent workflow:model-router
```

Den genauen Namen zeigt `/agents`. Als Subagent taugt er nicht, weil Subagents keine weiteren Subagents starten können.
