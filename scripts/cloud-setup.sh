#!/bin/bash
# Setup-Skript für Cloud-Umgebungen (claude.ai/code → Umgebung → „Setup script“).
# Installiert die Plugins aus diesem Marketplace für den Benutzer der Cloud-VM,
# bevor Claude Code startet. Gilt für jede Sitzung in dieser Umgebung, egal welches Repo.
#
# Plugins hinzufügen/entfernen: Liste PLUGINS anpassen.
# Neuere Version erzwingen: STAND ändern. Jede Änderung am Skript baut den
# Umgebungs-Cache neu, sonst läuft das Skript erst nach ca. 7 Tagen wieder.
STAND="2026-10-16"

MARKETPLACE_REPO="salvi1990/Agents_Skills"
PLUGINS="dev-team workflow"

claude plugin marketplace add "$MARKETPLACE_REPO" || claude plugin marketplace update agents-skills || true
for p in $PLUGINS; do
  claude plugin install "${p}@agents-skills" || true
  claude plugin update "${p}@agents-skills" || true
done

# Nie mit Fehler enden, sonst startet die Sitzung nicht.
exit 0
