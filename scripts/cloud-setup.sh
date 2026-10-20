#!/bin/bash
# Setup-Skript für Cloud-Umgebungen (claude.ai/code → Umgebung → „Setup-Skript“).
# Installiert die Plugins aus diesem Marketplace für den Benutzer der Cloud-VM,
# bevor Claude Code startet. Gilt für jede Sitzung in dieser Umgebung, egal welches Repo.
#
# Voraussetzung: Die Umgebung muss github.com erreichen, also Netzwerkzugriff
# „Vertrauenswürdig“, oder bei „Eingeschränkt“ github.com in den erlaubten Domains.
#
# Plugins hinzufügen/entfernen: Liste PLUGINS anpassen.
# Neuere Version erzwingen: STAND ändern. Jede Änderung am Skript baut den
# Umgebungs-Cache neu, sonst läuft das Skript erst nach ca. 7 Tagen wieder.
# Protokoll in der Sitzung ansehen: cat ~/.claude/agents-skills-setup.log
STAND="2026-10-20"

MARKETPLACE_REPO="salvi1990/Agents_Skills"
PLUGINS="dev-team workflow"

# Über HTTPS klonen; SSH ist in Cloud-Umgebungen meist nicht eingerichtet.
export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1

mkdir -p ~/.claude
{
  echo "== $(date) STAND=$STAND"
  claude plugin marketplace add "$MARKETPLACE_REPO" || claude plugin marketplace update agents-skills
  for p in $PLUGINS; do
    claude plugin install "${p}@agents-skills"
    claude plugin update "${p}@agents-skills"
  done
  claude plugin list
} >> ~/.claude/agents-skills-setup.log 2>&1

# Nie mit Fehler enden, sonst startet die Sitzung nicht.
exit 0
