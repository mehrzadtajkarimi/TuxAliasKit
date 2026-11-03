#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
INSTALL_DIR="$HOME/.local/share/tux-alias-kit"
BEGIN_MARKER='# >>> tux-alias-kit >>>'
END_MARKER='# <<< tux-alias-kit <<<'

if [[ ! -f "$BASHRC" ]] || ! grep -Fqx "$BEGIN_MARKER" "$BASHRC"; then
    echo 'بلوک نصب‌شده در ~/.bashrc پیدا نشد.'
    exit 0
fi

# حذف‌کننده فقط پس از تأیید کاربر، تنظیمات و فایل‌های نصب‌شدهٔ همین پروژه را پاک می‌کند.
read -r -p 'aliasها غیرفعال و فایل نصب‌شده حذف شود؟ [y/N] ' answer
case "$answer" in
    y|Y|yes|YES) ;;
    *) echo 'عملیات لغو شد.'; exit 0 ;;
esac

# از تنظیمات Bash پیش از حذف بلوک نسخهٔ پشتیبان می‌گیریم.
BACKUP="$BASHRC.bak.$(date +%Y%m%d-%H%M%S)"
cp -p "$BASHRC" "$BACKUP"

# فقط خطوط بین نشانگرهای همین پروژه حذف می‌شوند.
TEMP_BASHRC="$(mktemp "$HOME/.bashrc.tmp.XXXXXX")"
trap 'rm -f "$TEMP_BASHRC"' EXIT
awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
    $0 == begin { skipping = 1; next }
    $0 == end { skipping = 0; next }
    !skipping { print }
' "$BASHRC" > "$TEMP_BASHRC"
chmod "$(stat -c '%a' "$BASHRC")" "$TEMP_BASHRC"
mv "$TEMP_BASHRC" "$BASHRC"
trap - EXIT

# پوشه فقط وقتی خالی باشد پاک می‌شود تا فایل دیگری حذف نشود.
rm -f "$INSTALL_DIR/aliases.sh"
rmdir "$INSTALL_DIR" 2>/dev/null || true

echo 'aliasها حذف شدند. برای اعمال تغییر در همین ترمینال اجرا کنید: source ~/.bashrc'
