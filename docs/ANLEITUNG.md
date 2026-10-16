# Anleitung: Plugins installieren und verwenden

Diese Anleitung erklärt, wie du die Agents und Skills aus diesem Repository in anderen Repositories einsetzt, getrennt nach **CLI** und **Web**.

- **CLI** umfasst das Terminal (`claude`), lokale Sitzungen in der Desktop-App und die IDE-Erweiterungen (VS Code, JetBrains). Alle lesen dieselben Einstellungsdateien auf deinem Rechner.
- **Web** umfasst Cloud-Sessions: [claude.ai/code](https://claude.ai/code) im Browser, der Code-Tab der Claude-App, „Cloud“ in der Desktop-App und `claude --cloud`. Diese Sitzungen laufen auf einer frischen VM bei Anthropic, nicht auf deinem Rechner.

## Inhalt

1. [Begriffe und Namen](#1-begriffe-und-namen)
2. [CLI: installieren](#2-cli-installieren)
3. [Web: installieren](#3-web-installieren)
4. [Verwenden (CLI und Web)](#4-verwenden-cli-und-web)
5. [Updates](#5-updates)
6. [Fehlerbehebung](#6-fehlerbehebung)

---

## 1. Begriffe und Namen

| Begriff | Was es ist | In diesem Repo |
|---|---|---|
| **Marketplace** | Katalog von Plugins, hier das ganze Repository | `agents-skills` (Name aus `.claude-plugin/marketplace.json`, nicht der Repo-Name) |
| **Plugin** | Paket aus Agents und Skills, wird als Ganzes installiert | `dev-team`, `workflow` |
| **Agent** (Subagent) | Rolle mit eigenem Systemprompt und eigenem Kontextfenster | z.B. `db-entwickler` |
| **Skill** | Anleitung, die Claude bei Bedarf lädt, aufrufbar mit `/` | z.B. `db`, `grille-mich` |

Die Namen setzen sich so zusammen:

| Was | Schema | Beispiel |
|---|---|---|
| Plugin installieren | `<plugin>@<marketplace>` | `dev-team@agents-skills` |
| Skill aufrufen | `/<plugin>:<skill>` | `/dev-team:db` |
| Agent ansprechen | `<plugin>:<agent>` | `dev-team:db-entwickler` |

---

## 2. CLI: installieren

Voraussetzung: Claude Code ist installiert (`claude --version`) und du hast Lesezugriff auf `salvi1990/Agents_Skills`. Bei einem privaten Repo muss `git` ohne Passwortabfrage klonen können, z.B. nach `gh auth login` und `gh auth setup-git` oder mit einem SSH-Schlüssel im `ssh-agent`.

Es gibt drei **Scopes**. Wähle danach, für wen das Plugin gelten soll:

| Scope | Gilt für | Gespeichert in |
|---|---|---|
| `user` | dich, in allen Projekten auf diesem Rechner | `~/.claude/settings.json` |
| `project` | alle, die im Repo arbeiten (wird committet) | `.claude/settings.json` im Repo |
| `local` | dich, nur in diesem Repo | `.claude/settings.local.json` im Repo |

### 2a. Für dich in allen Projekten (empfohlen für den Einstieg)

**In der Shell**, ohne eine Sitzung zu starten:

```bash
claude plugin marketplace add salvi1990/Agents_Skills
claude plugin install dev-team@agents-skills
claude plugin install workflow@agents-skills
```

**Oder in einer laufenden Sitzung:**

```
/plugin marketplace add salvi1990/Agents_Skills
/plugin install dev-team@agents-skills
```

`/plugin install` öffnet ein Fenster mit den Inhalten des Plugins. Dort wählst du den Scope („Install for you“ = `user`). Mit `/plugin` ohne Argument kannst du im Tab **Discover** stöbern.

Danach sind die Plugins in jeder neuen Sitzung aktiv. In einer bereits laufenden Sitzung lädt `/reload-plugins` sie nach.

### 2b. Für ein bestimmtes Repo, z.B. „PostgreSQL“

So steht im Repo fest, welche Plugins es nutzt, und alle Mitarbeitenden bekommen dieselbe Ausstattung.

1. Im Ziel-Repo die Datei `.claude/settings.json` anlegen oder ergänzen. Nur die Plugins aktivieren, die das Repo braucht:

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

   Alternativ schreibt Claude Code die Datei selbst, wenn du im Ziel-Repo ausführst:

   ```bash
   claude plugin marketplace add salvi1990/Agents_Skills --scope project
   claude plugin install dev-team@agents-skills --scope project
   ```

2. Datei committen und pushen.
3. **Jede Person einmal pro Rechner:** Repo öffnen, `claude` starten und dem Ordner vertrauen (Trust-Dialog). Damit wird der Marketplace registriert. Die Datei schaltet das Plugin nur ein, heruntergeladen ist es damit noch nicht. Falls Claude meldet, dass ein aktiviertes Plugin nicht installiert ist:

   ```bash
   claude plugin install dev-team@agents-skills --scope project
   ```

> **Achtung:** `claude plugin marketplace remove agents-skills` deinstalliert alle Plugins daraus und **löscht deren Einträge auch aus `.claude/settings.json` des aktuellen Repos**. Danach also `git diff` prüfen.

### 2c. Kontrollieren, was installiert ist

| Befehl | Zeigt |
|---|---|
| `/` tippen (in der Sitzung) | Liste aller Skills, z.B. `/dev-team:db` |
| `/agents` (in der Sitzung) | Alle verfügbaren Agents, z.B. `dev-team:db-entwickler` |
| `/plugin` → Tab **Installed** | Installierte Plugins mit Scope, aktivieren, deaktivieren, entfernen |
| `claude plugin list` (Shell) | Plugins mit Version, Scope und Status |
| `claude plugin details dev-team` (Shell) | Enthaltene Agents/Skills und Tokenkosten pro Sitzung |

### 2d. Deaktivieren oder entfernen

```bash
claude plugin disable workflow@agents-skills     # bleibt installiert, ist aber aus
claude plugin enable workflow@agents-skills
claude plugin uninstall workflow@agents-skills   # Scope ggf. mit --scope project
```

Möchtest du ein Plugin, das das Repo per `.claude/settings.json` einschaltet, nur für dich ausschalten: `/plugin` → Installed → Plugin → **Uninstall** → `y` („Disable for me“). Das schreibt `false` in deine `.claude/settings.local.json`.

---

## 3. Web: installieren

In Cloud-Sessions gelten andere Regeln:

| Was | Wirkt im Web? |
|---|---|
| `/plugin`-Befehle | **Nein**, nicht verfügbar |
| Plugins aus `.claude/settings.json` des Repos (`enabledPlugins`, `extraKnownMarketplaces`) | **Nein**, werden in Cloud-Sessions nicht installiert |
| Plugins, die du lokal mit `user`-Scope installiert hast | **Nein**, die liegen auf deinem Rechner |
| Agents/Skills, die direkt im Repo unter `.claude/agents/` und `.claude/skills/` liegen | Ja |
| **Setup-Skript der Cloud-Umgebung** | Ja, läuft vor dem Start von Claude Code |
| Skills, die du auf claude.ai aktiviert hast | Ja, nur Skills, keine Agents |

Darum gibt es im Web zwei sinnvolle Wege.

### 3a. Setup-Skript der Cloud-Umgebung (empfohlen)

Das Setup-Skript installiert die Plugins auf der Cloud-VM, bevor Claude Code startet. Es gilt für **alle Repos**, die du mit dieser Umgebung öffnest. Du musst dafür in keinem Ziel-Repo etwas ändern.

1. [claude.ai/code](https://claude.ai/code) öffnen.
2. Unten bei der Auswahl der Umgebung (z.B. „Default“) die Einstellungen der Umgebung öffnen, oder über **Settings → Cloud environments**.
3. Inhalt von [`scripts/cloud-setup.sh`](../scripts/cloud-setup.sh) in das Feld **Setup script** kopieren und speichern.
4. Netzwerkzugriff der Umgebung mindestens auf **Trusted** lassen, damit GitHub erreichbar ist.
5. **Neue** Sitzung starten. Bereits laufende Sitzungen bekommen das Skript nicht.

Das Skript wird nach dem ersten Lauf zwischengespeichert. Neue Sitzungen starten aus diesem Zwischenstand, ohne das Skript erneut auszuführen. Wie du Updates holst, steht in [Abschnitt 5](#5-updates).

Brauchst du in verschiedenen Repos verschiedene Plugins, lege mehrere Umgebungen an, z.B. „DB-Arbeit“ mit nur `dev-team`, und wähle beim Start der Sitzung die passende.

> Getestet: Nach `claude plugin marketplace add` und `claude plugin install` auf einer Cloud-VM sind `/dev-team:…`, die Agents und `claude --agent workflow:model-router` im danach gestarteten Claude Code verfügbar. Ist das Repo `salvi1990/Agents_Skills` privat, muss die Umgebung es klonen können. Am einfachsten ist ein öffentliches Repo.

### 3b. Agents und Skills ins Ziel-Repo kopieren (Notlösung)

Ohne Setup-Skript funktioniert nur, was im Repo selbst liegt:

```bash
# im Ziel-Repo
mkdir -p .claude/agents .claude/skills
cp <pfad-zu>/Agents_Skills/plugins/dev-team/agents/*.md .claude/agents/
cp -R <pfad-zu>/Agents_Skills/plugins/dev-team/skills/* .claude/skills/
```

Nachteile: Die Dateien sind dann doppelt vorhanden und werden nicht automatisch aktualisiert. Die Namen haben **kein** Plugin-Präfix mehr (`/db` statt `/dev-team:db`, Agent `db-entwickler` statt `dev-team:db-entwickler`). Nur nutzen, wenn 3a nicht geht.

### 3c. Team- oder Enterprise-Plan

Auf diesen Plänen kann ein Owner den Marketplace unter **Organization settings → Plugins & skills** auf claude.ai für alle Mitglieder verteilen. Das wirkt dann auch in Cloud-Sessions. Für ein persönliches Konto ist 3a der Weg.

---

## 4. Verwenden (CLI und Web)

Die Nutzung ist überall gleich, sobald die Plugins geladen sind.

### Per `/`-Befehl

```
/dev-team:db Lege eine Migration für die Tabelle orders mit Index auf customer_id an
/dev-team:tester Schreib Tests für src/billing/invoice.py und führ sie aus
/dev-team:architekt Bewerte, ob wir das Reporting in einen eigenen Service auslagern sollen
/dev-team:frontend Baue ein Formular zum Anlegen eines Kunden mit Validierung
/dev-team:backend Füge einen Endpunkt GET /customers/{id}/orders mit Paginierung hinzu
/workflow:grille-mich Ich will unsere Oracle-DB nach PostgreSQL migrieren
/workflow:model-router Warum hängt unsere Replikation seit gestern?
```

Ohne Text nach dem Befehl fragt Claude nach der Aufgabe. Was im Gespräch schon besprochen wurde (Dateien, Fehlermeldungen), gibt Claude dem Agent mit.

### Ohne `/`-Befehl

- **Automatisch:** Claude delegiert selbst an einen Agent, wenn die Aufgabe zu dessen Beschreibung passt, z.B. „Optimiere diese langsame SQL-Abfrage“ → `db-entwickler`.
- **Gezielt:** den Agent im Text nennen, z.B. „Lass `dev-team:software-tester` die Tests für das Modul schreiben“, oder mit `@` erwähnen (`@dev-team:software-tester`), wo die Oberfläche das anbietet.

### Model-Router als Hauptagent

| | CLI | Web |
|---|---|---|
| Ganze Sitzung über den Router | `claude --agent workflow:model-router` | Nicht als Startoption verfügbar |
| Einzelne Anfrage über den Router | `/workflow:model-router <Anfrage>` | `/workflow:model-router <Anfrage>` |

### Welche Rolle wofür?

| Aufgabe | Befehl |
|---|---|
| Schema, Migration, SQL, Index, Ausführungsplan, Backup, Replikation | `/dev-team:db` |
| Tests schreiben/ausführen, Bug reproduzieren, Testlücken | `/dev-team:tester` |
| Grundsatzentscheidung, Entwurf, Review der Struktur, ADR | `/dev-team:architekt` |
| UI, Komponenten, Styling, Barrierefreiheit | `/dev-team:frontend` |
| API, Geschäftslogik, Auth, Jobs, Integrationen | `/dev-team:backend` |
| Idee noch unscharf, Entscheidungen offen | `/workflow:grille-mich` |

Tipp: Lege im Ziel-Repo eine `CLAUDE.md` mit den projektspezifischen Befehlen an (Tests starten, Migrationen ausführen, Konventionen). Die Agents lesen sie als Erstes und arbeiten dann genauer.

---

## 5. Updates

Änderungen an diesem Repo kommen nur an, wenn die `version` in `plugins/<plugin>/.claude-plugin/plugin.json` erhöht wurde (siehe `CLAUDE.md`) und der Stand im Default-Branch liegt.

| | Update holen |
|---|---|
| **CLI, von Hand** | In der Sitzung `/plugin marketplace update agents-skills`, oder in der Shell `claude plugin update dev-team@agents-skills` |
| **CLI, automatisch** | Einmalig `/plugin` → Tab **Marketplaces** → `agents-skills` → **Enable auto-update**. Danach aktualisiert Claude Code im Hintergrund, aktiv ab der nächsten Sitzung oder nach `/reload-plugins` |
| **Web (Setup-Skript)** | In `scripts/cloud-setup.sh` bzw. im Feld der Umgebung die Zeile `STAND=` ändern und speichern. Dadurch läuft das Skript bei der nächsten neuen Sitzung erneut. Ohne Änderung passiert das spätestens nach etwa 7 Tagen |
| **Web (kopiert)** | Dateien erneut kopieren und committen |

Einen bestimmten Stand festhalten: beim Hinzufügen `#<branch-oder-tag>` anhängen, z.B. `salvi1990/Agents_Skills#v1.0.0`.

---

## 6. Fehlerbehebung

| Problem | Lösung |
|---|---|
| `/dev-team:…` erscheint nicht (CLI) | `claude plugin list` prüfen; ggf. `/reload-plugins` oder neue Sitzung |
| `/dev-team:…` erscheint nicht (Web) | Setup-Skript gespeichert? **Neue** Sitzung in **dieser** Umgebung gestartet? Netzwerk mindestens „Trusted“? |
| `Plugin "…" not found in marketplace` | Marketplace-Name ist `agents-skills`, nicht `Agents_Skills`. `claude plugin marketplace list` zeigt die Namen |
| Klonen schlägt fehl (privates Repo) | `gh auth login` und `gh auth setup-git`, oder SSH-Schlüssel ohne Passwortabfrage. Ohne SSH-Schlüssel hilft `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` |
| Änderung aus diesem Repo kommt nicht an | Version im `plugin.json` erhöht? Gemergt? Update geholt (Abschnitt 5)? |
| Plugin in `.claude/settings.json` aktiviert, aber „not installed“ | `claude plugin install <plugin>@agents-skills --scope project` |
| Neue Plugins lokal testen, ohne zu mergen | `claude --plugin-dir ./plugins/dev-team --plugin-dir ./plugins/workflow` im Klon dieses Repos |

Offizielle Doku: [Plugins installieren](https://code.claude.com/docs/en/plugins/install) · [Cloud-Umgebungen](https://code.claude.com/docs/en/cloud-environments) · [Marketplace betreiben](https://code.claude.com/docs/en/plugins/host-marketplace)
