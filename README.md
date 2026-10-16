# Agents & Skills

Sammlung wiederverwendbarer Claude-Code-Agents und -Skills, organisiert als **Plugin-Marketplace**. Einmal hier gepflegt, in jedem Repository nutzbar.

## Inhalt

| Plugin | Aufruf | Agent | Zweck |
|---|---|---|---|
| `dev-team` | `/dev-team:db <Aufgabe>` | `db-entwickler` | DB-Entwicklung & -Administration: Schema, Migrationen, SQL, Tuning, Backup/HA |
| | `/dev-team:tester <Aufgabe>` | `software-tester` | Tests schreiben und ausführen, Testlücken, Fehler reproduzieren |
| | `/dev-team:architekt <Aufgabe>` | `software-architekt` | Architekturentscheidungen, Entwürfe, Reviews, ADRs (schreibt keinen Produktivcode) |
| | `/dev-team:frontend <Aufgabe>` | `frontend-entwickler` | UI-Komponenten, Styling, State, Barrierefreiheit |
| | `/dev-team:backend <Aufgabe>` | `backend-entwickler` | APIs, Geschäftslogik, Auth, Datenzugriff, Jobs |
| `workflow` | `/workflow:model-router` | `model-router` | Anfrage einstufen und an Sonnet, Opus oder Fable delegieren |
| | `/workflow:grille-mich <Idee>` | – | Plan oder Idee im Interview schärfen, Runde für Runde |

Die Agents werden auch **ohne** `/`-Befehl genutzt: Claude delegiert automatisch, wenn die Aufgabe zur Beschreibung eines Agents passt. Ausdrücklich geht es auch mit `@`-Erwähnung, z.B. `@dev-team:db-entwickler`.

Den Model-Router als Hauptagent für eine ganze Sitzung starten:

```bash
claude --agent workflow:model-router
```

## In einem anderen Repository verwenden

**Variante A, empfohlen: im Ziel-Repo fest eintragen.** Gilt dann automatisch für alle, die das Repo öffnen, auch in Cloud-Sessions. Datei `.claude/settings.json` im Ziel-Repo:

```json
{
  "extraKnownMarketplaces": {
    "agents-skills": {
      "source": { "source": "github", "repo": "salvi1990/Agents_Skills" }
    }
  },
  "enabledPlugins": {
    "dev-team@agents-skills": true,
    "workflow@agents-skills": true
  }
}
```

Nur aktivieren, was das Repo braucht: Jedes aktivierte Plugin kostet ein paar hundert Tokens Kontext pro Sitzung (`claude plugin details <plugin>` zeigt die Zahlen).

**Variante B: einmalig von Hand**, für deinen Benutzer in allen Projekten:

```
/plugin marketplace add salvi1990/Agents_Skills
/plugin install dev-team@agents-skills
/plugin install workflow@agents-skills
```

Updates holen: `/plugin marketplace update agents-skills`.

Dieses Repository selbst nutzt Variante A (`.claude/settings.json`). Die Plugins werden vom Default-Branch auf GitHub geladen, Änderungen gelten also erst nach dem Merge.

## Aufbau

```
.claude-plugin/marketplace.json     Verzeichnis aller Plugins
.claude/settings.json               Plugins für dieses Repo selbst aktivieren
plugins/
  <plugin>/
    .claude-plugin/plugin.json      Name, Version, Beschreibung
    agents/<agent>.md               Subagents (Systemprompt + Frontmatter)
    skills/<skill>/SKILL.md         /-Befehle und Wissens-Skills
templates/                          Vorlagen für neue Agents, Skills, Plugins
scripts/validate.sh                 Prüft Marketplace und alle Plugins
```

Konventionen:

- **Ein Plugin pro Themengebiet** (z.B. `dev-team`, `workflow`, später `devops`, `security`). So aktiviert jedes Ziel-Repo nur, was es braucht.
- **Agent = Rolle mit eigenem Kontext**, **Skill = `/`-Befehl oder Wissen**, das bei Bedarf geladen wird. Für jede Rolle gibt es einen kurzen Skill, der an den Agent delegiert, damit sie per `/` aufrufbar ist.
- `/`-Befehle von Plugins sind immer `/<plugin>:<skill>`, Agents heißen `<plugin>:<agent>`.
- Allgemeines gehört hierher, Projektspezifisches (Befehle, Konventionen eines Repos) in die `CLAUDE.md` des Ziel-Repos. Die Agents lesen diese zuerst.

## Erweitern

**Neuer Agent in bestehendem Plugin**

1. `templates/agent.md` nach `plugins/<plugin>/agents/<name>.md` kopieren und ausfüllen. Die `description` entscheidet, wann Claude delegiert, also konkret formulieren.
2. Optional einen `/`-Befehl: `templates/skill/SKILL.md` nach `plugins/<plugin>/skills/<kurzname>/SKILL.md` kopieren (Abschnitt „Variante: Skill, der an einen Agent delegiert“).
3. `version` in `plugins/<plugin>/.claude-plugin/plugin.json` erhöhen, sonst bekommen installierte Repos das Update nicht.
4. Tabelle oben ergänzen, `./scripts/validate.sh` ausführen.

**Neues Plugin**

1. Ordner `plugins/<name>/` anlegen, `templates/plugin.json` nach `plugins/<name>/.claude-plugin/plugin.json` kopieren.
2. Eintrag in `.claude-plugin/marketplace.json` unter `plugins` ergänzen.
3. `./scripts/validate.sh` ausführen.

**Lokal testen ohne Merge**

```bash
claude --plugin-dir ./plugins/dev-team --plugin-dir ./plugins/workflow
```

## Quellen und Lizenzen

- `grille-mich`: deutsche Fassung von Jonas Keil des Skills `grill-me` von Matt Pocock (MIT). Details in `plugins/workflow/skills/grille-mich/README.md`.
