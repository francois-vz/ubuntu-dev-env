#!/usr/bin/env bash
# run.sh — Ubuntu 24.04 "Ubuntu 20 style" snapping:
# Drag-to-top maximize, Super+Up maximize, Super+Down restore,
# Super+Left/Right half-screen, and no layout chooser popup.

set -euo pipefail

have_schema() { gsettings list-schemas | grep -qx "$1"; }
have_key() { gsettings range "$1" "$2" >/dev/null 2>&1; }

set_first_existing_key() {
    local schema="$1" value="$2"; shift 2
    for key in "$@"; do
        if have_key "$schema" "$key"; then
            gsettings set "$schema" "$key" "$value"
            echo "Set $schema $key = $value"
            return 0
        fi
    done
    echo "WARN: none of these keys exist in $schema: $*"
    return 1
}

# 1) Keep classic edge tiling + disable experimental tiling UI (often removes layout chooser popup)
if have_schema org.gnome.mutter; then
    gsettings set org.gnome.mutter edge-tiling true
    gsettings set org.gnome.mutter experimental-features "[]"
    echo "Set org.gnome.mutter edge-tiling=true and experimental-features=[]"
fi

# 2) Set maximize / restore shortcuts (stable keys)
if have_schema org.gnome.desktop.wm.keybindings; then
    if have_key org.gnome.desktop.wm.keybindings maximize; then
        gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
        echo "Set maximize = Super+Up"
    fi
    # Some GNOME versions use 'unmaximize', some have 'toggle-maximized'
    if have_key org.gnome.desktop.wm.keybindings unmaximize; then
        gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
        echo "Set unmaximize = Super+Down"
        elif have_key org.gnome.desktop.wm.keybindings toggle-maximized; then
        gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
        echo "Set toggle-maximized = Super+Up (fallback)"
    fi
    
    # 3) Set snap left/right using whatever key names exist on your system
    # We try common GNOME variants.
    set_first_existing_key org.gnome.desktop.wm.keybindings "['<Super>Left']" \
    tile-left tile-to-side-w tile-to-side-left tile-to-side-west || true
    
    set_first_existing_key org.gnome.desktop.wm.keybindings "['<Super>Right']" \
    tile-right tile-to-side-e tile-to-side-right tile-to-side-east || true
fi

# 4) If a tiling assistant extension schema exists, disable its popup/overlay too
if have_schema org.gnome.shell.extensions.tiling-assistant; then
    if have_key org.gnome.shell.extensions.tiling-assistant enable-tiling-popup; then
        gsettings set org.gnome.shell.extensions.tiling-assistant enable-tiling-popup false
        echo "Disabled tiling-assistant popup"
    fi
    if have_key org.gnome.shell.extensions.tiling-assistant show-layout-panel; then
        gsettings set org.gnome.shell.extensions.tiling-assistant show-layout-panel false
        echo "Disabled tiling-assistant layout panel"
    fi
fi

echo "Done. If the popup still appears, log out and back in."