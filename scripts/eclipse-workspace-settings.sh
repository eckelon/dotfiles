#!/bin/sh
# Ajustes de Eclipse que no viven en el home sino en cada workspace.
#
#   ./scripts/eclipse-workspace-settings.sh                 # workspaces por defecto
#   ./scripts/eclipse-workspace-settings.sh /ruta/workspace
#
# Qué hace en cada workspace:
#   - tema claro "Moon" de Planet Themes (macOS en modo oscuro ponia Eclipse en dark)
#   - Oomph no se activa al arrancar (es quien muestra el aviso de sponsor)
#
# Cierra Eclipse antes de ejecutarlo: al salir reescribe sus preferencias.
set -e

SETTINGS=".metadata/.plugins/org.eclipse.core.runtime/.settings"
THEME="io.github.pyvesb.eclipse_planet_themes.moon"
SKIP=";org.eclipse.m2e.discovery;org.eclipse.oomph.setup.ui;org.eclipse.oomph.setup.editor;org.eclipse.oomph.setup.presentation;"

workspaces="$*"
[ -z "$workspaces" ] && workspaces="$HOME/Developer/2dgame $HOME/eclipse-workspace"

for workspace in $workspaces; do
    if [ ! -d "$workspace" ]; then
        echo "salto: $workspace no existe"
        continue
    fi
    mkdir -p "$workspace/$SETTINGS"
    printf 'eclipse.preferences.version=1\nthemeid=%s\n' "$THEME" \
        > "$workspace/$SETTINGS/org.eclipse.e4.ui.css.swt.theme.prefs"
    prefs="$workspace/$SETTINGS/org.eclipse.ui.workbench.prefs"
    if [ -f "$prefs" ]; then
        if grep -q '^PLUGINS_NOT_ACTIVATED_ON_STARTUP=' "$prefs"; then
            sed -i.bak "s|^PLUGINS_NOT_ACTIVATED_ON_STARTUP=.*|PLUGINS_NOT_ACTIVATED_ON_STARTUP=$SKIP|" "$prefs"
            rm -f "$prefs.bak"
        else
            printf 'PLUGINS_NOT_ACTIVATED_ON_STARTUP=%s\n' "$SKIP" >> "$prefs"
        fi
    else
        printf 'eclipse.preferences.version=1\nPLUGINS_NOT_ACTIVATED_ON_STARTUP=%s\n' "$SKIP" > "$prefs"
    fi
    echo "configurado: $workspace"
done
