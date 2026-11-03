#!/usr/bin/env bash

# این فایل را می‌توان مستقیماً در Bash بارگذاری کرد یا با install.sh نصب کرد.

# میانبرهای عمومی ترمینال و فایل‌ها
alias c='clear'                         # پاک کردن صفحهٔ ترمینال
alias p='pwd'                           # نمایش مسیر پوشهٔ فعلی
alias l='ls --color=auto'               # فهرست ساده با رنگ‌بندی فایل‌ها
alias ll='ls -lah --color=auto'         # فهرست کامل، شامل فایل‌های مخفی و اندازهٔ خوانا
alias h='history'                       # نمایش تاریخچهٔ فرمان‌ها
alias ..='cd ..'                        # رفتن به پوشهٔ والد
alias ...='cd ../..'                    # رفتن دو سطح بالاتر
alias m='mkdir -p'                      # ساخت پوشه و والدهای لازم
alias grep='grep --color=auto'          # رنگی‌کردن نتیجه‌های grep در ترمینال

# میانبرهای Git؛ فرمان‌ها در مخزن فعلی اجرا می‌شوند.
alias gs='git status --short --branch'  # وضعیت فشردهٔ مخزن و شاخهٔ فعلی
alias gl='git log --oneline --decorate -10' # ده ثبت آخر به شکل خلاصه
alias gd='git diff'                     # دیدن تغییرات ثبت‌نشده
alias ga='git add'                      # افزودن فایل‌ها به مرحلهٔ آماده‌سازی ثبت
alias gc='git commit'                   # ثبت تغییرات آماده‌شده

# میانبرهای مشاهده و کار روزمره با Docker
alias dps='docker ps'                   # نمایش کانتینرهای در حال اجرا
alias dpa='docker ps -a'                # نمایش همهٔ کانتینرها، از جمله متوقف‌شده‌ها
alias dimg='docker image ls'            # نمایش تصویرهای Docker
alias dvol='docker volume ls'           # نمایش volumeها بدون حذف آن‌ها
alias dcu='docker compose up'           # بالا آوردن سرویس‌های Compose
alias dcud='docker compose up -d'       # بالا آوردن سرویس‌های Compose در پس‌زمینه
alias dcd='docker compose down'         # متوقف و جمع‌کردن سرویس‌های Compose پروژهٔ فعلی

# میانبرهای Laravel؛ در پوشهٔ یک پروژهٔ Laravel استفاده شوند.
alias pa='php artisan'                  # میانبر پایه برای اجرای Artisan
alias pat='php artisan tinker'          # باز کردن محیط تعاملی Tinker
alias pamodel='php artisan make:model'  # ساخت مدل
alias pacontroller='php artisan make:controller' # ساخت کنترلر
alias pamigration='php artisan make:migration' # ساخت فایل مایگریشن
alias pamiddleware='php artisan make:middleware' # ساخت middleware
alias paroutes='php artisan route:list' # نمایش فهرست routeها
alias pa-migrate='php artisan migrate'  # اجرای مایگریشن‌های اجرا‌نشدهٔ پروژه

# تبدیل تصویر به WebP؛ به نصب cwebp نیاز دارد.
webp_convert() {
    # راهنمای کوتاه را در صورت نبود ورودی یا تعداد آرگومان نامعتبر نشان بده.
    if [[ $# -lt 1 || $# -gt 3 ]]; then
        echo 'روش استفاده: webp_convert <تصویر> [نام-خروجی] [کیفیت]'
        echo 'نمونه: webp_convert photo.jpg result 85'
        return 2
    fi

    local input="$1"
    local output=""
    local quality=80

    # آرگومان دوم می‌تواند کیفیت یا نام فایل خروجی باشد.
    if [[ $# -ge 2 ]]; then
        if [[ "$2" =~ ^[0-9]+$ ]]; then
            quality="$2"
        else
            output="$2"
        fi
    fi

    # آرگومان سوم، در صورت وجود، کیفیت خروجی را مشخص می‌کند.
    if [[ $# -eq 3 ]]; then
        quality="$3"
    fi

    # ورودی باید فایل موجود باشد تا ابزار روی مسیر اشتباه اجرا نشود.
    if [[ ! -f "$input" ]]; then
        echo "خطا: فایل ورودی پیدا نشد: $input" >&2
        return 1
    fi

    # بررسی وابستگی پیش از اجرا، با پیام راهنمای قابل‌فهم.
    if ! command -v cwebp >/dev/null 2>&1; then
        echo 'خطا: cwebp نصب نیست؛ بستهٔ WebP را از مخازن توزیع خود نصب کنید.' >&2
        return 1
    fi

    # کیفیت cwebp باید عدد صحیحی بین ۱ تا ۱۰۰ باشد.
    if [[ ! "$quality" =~ ^[0-9]+$ ]] || (( quality < 1 || quality > 100 )); then
        echo 'خطا: کیفیت باید عددی بین ۱ تا ۱۰۰ باشد.' >&2
        return 2
    fi

    # اگر نام خروجی داده نشده باشد، نام فایل ورودی با پسوند WebP استفاده می‌شود.
    if [[ -z "$output" ]]; then
        output="${input%.*}.webp"
    fi

    # پسوند خروجی را یکدست نگه می‌داریم تا نام فایل گمراه‌کننده نباشد.
    case "$output" in
        *.webp|*.WEBP) ;;
        *) output="${output}.webp" ;;
    esac

    # برای جلوگیری از بازنویسی ناخواسته، فایل موجود را دست‌نخورده می‌گذاریم.
    if [[ -e "$output" ]]; then
        echo "خطا: فایل خروجی از قبل وجود دارد: $output" >&2
        return 1
    fi

    # نام فایل‌ها به صورت نقل‌قول‌شده به cwebp داده می‌شود تا فاصله‌ها درست باشند.
    cwebp -q "$quality" "$input" -o "$output" || return $?
    echo "تصویر ساخته شد: $output"
}
