// SPDX-License-Identifier: GPL-2.0-or-later

import St from 'gi://St';

import {Extension, gettext as _} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';

export default class TuxAliasKitExtension extends Extension {
    enable() {
        this._indicator = new PanelMenu.Button(0.0, _('TuxAliasKit'));
        this._indicator.add_child(new St.Icon({
            icon_name: 'utilities-terminal-symbolic',
            style_class: 'system-status-icon',
        }));

        const preferencesItem = new PopupMenu.PopupMenuItem(_('Manage Bash aliases and functions'));
        preferencesItem.connect('activate', () => this.openPreferences());
        this._indicator.menu.addMenuItem(preferencesItem);

        Main.panel.addToStatusArea(this.uuid, this._indicator);
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = null;
    }
}
