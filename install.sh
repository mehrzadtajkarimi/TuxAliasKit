#!/usr/bin/env bash
set -euo pipefail

# مسیر پروژه از محل همین اسکریپت پیدا می‌شود تا نصب از هر پوشه‌ای ممکن باشد.
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/share/tux-alias-kit"
BASHRC="$HOME/.bashrc"
BEGIN_MARKER='# >>> tux-alias-kit >>>'
END_MARKER='# <<< tux-alias-kit <<<'

# فقط فایل این پروژه در مسیر اختصاصی خودش کپی می‌شود.
mkdir -p "$INSTALL_DIR"
install -m 0644 "$PROJECT_DIR/aliases.sh" "$INSTALL_DIR/aliases.sh"

# فایل موقت کنار .bashrc ساخته می‌شود تا جایگزینی نهایی در همان فایل‌سیستم باشد.
TEMP_BASHRC="$(mktemp "$HOME/.bashrc.tmp.XXXXXX")"
trap 'rm -f "$TEMP_BASHRC"' EXIT

if [[ -f "$BASHRC" ]]; then
    # پیش از ویرایش، نسخهٔ فعلی تنظیمات Bash را نگه می‌داریم.
    BACKUP="$BASHRC.bak.$(date +%Y%m%d-%H%M%S)"
    cp -p "$BASHRC" "$BACKUP"

    # بلوک قبلی همین پروژه حذف می‌شود تا نصب دوباره خط تکراری نسازد.
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
        $0 == begin { skipping = 1; next }
        $0 == end { skipping = 0; next }
        !skipping { print }
    ' "$BASHRC" > "$TEMP_BASHRC"
    chmod "$(stat -c '%a' "$BASHRC")" "$TEMP_BASHRC"
else
    # اگر .bashrc وجود نداشته، فایل تنظیمات را با مجوز خصوصی می‌سازیم.
    chmod 600 "$TEMP_BASHRC"
fi

# بلوک مدیریت‌شده فقط فایل نصب‌شده را بارگذاری می‌کند.
{
    if [[ -s "$TEMP_BASHRC" ]]; then
        printf '\n'
    fi
    printf '%s\n' \
        "$BEGIN_MARKER" \
        'if [[ -f "$HOME/.local/share/tux-alias-kit/aliases.sh" ]]; then' \
        '    source "$HOME/.local/share/tux-alias-kit/aliases.sh"' \
        'fi' \
        "$END_MARKER"
} >> "$TEMP_BASHRC"

mv "$TEMP_BASHRC" "$BASHRC"
trap - EXIT

echo 'نصب انجام شد. برای فعال‌سازی در همین ترمینال اجرا کنید: source ~/.bashrc'
