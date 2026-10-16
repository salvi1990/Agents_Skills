---
name: skill-name
description: <Was der Skill tut und WANN er greifen soll, mit typischen Formulierungen des Nutzers.> Aufruf mit /<plugin>:skill-name <Argumente>.
argument-hint: <Argumente>
# disable-model-invocation: true   # nur per / aufrufbar, Claude lädt ihn nicht selbst
---

<Anweisungen an Claude. Die Argumente des Aufrufs stehen in $ARGUMENTS.>

## Variante: Skill, der an einen Agent delegiert

Übergib die Aufgabe an den Subagent `<agent-name>` (ggf. als `<plugin>:<agent-name>` geführt).

Aufgabe: $ARGUMENTS

1. Ohne Aufgabe kurz nachfragen.
2. Dem Subagent die Aufgabe im Wortlaut plus relevanten Kontext aus dem Gespräch mitgeben.
3. Ergebnis unverändert weitergeben, offene Punkte nennen.
