# CLAUDE.md

Dieses Repository ist ein Claude-Code-Plugin-Marketplace mit Agents und Skills, die in anderen Repositories wiederverwendet werden. Aufbau und Konventionen stehen in `README.md`.

## Regeln für Änderungen

- Inhalte (Agents, Skills, Doku) auf Deutsch schreiben.
- Neue Agents/Skills/Plugins aus den Vorlagen in `templates/` erstellen.
- Jedes Plugin unter `plugins/` muss in `.claude-plugin/marketplace.json` eingetragen sein.
- Bei jeder inhaltlichen Änderung an einem Plugin dessen `version` in `.claude-plugin/plugin.json` erhöhen (SemVer).
- Agents bleiben projektunabhängig: keine Pfade, Befehle oder Namen eines bestimmten Ziel-Repos. Stattdessen anweisen, die `CLAUDE.md`/`README` des Ziel-Repos zu lesen.
- Neue Rollen-Agents bekommen einen delegierenden Skill, damit sie per `/<plugin>:<skill>` aufrufbar sind.
- Tabelle „Inhalt“ in `README.md` aktuell halten.
- Vor jedem Commit `./scripts/validate.sh` ausführen.
