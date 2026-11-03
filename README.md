# TuxAliasKit

افزونهٔ GNOME Shell برای مدیریت گرافیکی Aliasها و تابع‌های Bash، از جمله `webp_convert`. فهرست‌ها از تنظیمات افزونه در برنامهٔ **GNOME Extensions** باز می‌شوند.

## نصب محلی برای توسعه

این بسته فقط برای توسعهٔ محلی آماده است. در GNOME 48، افزونه را بساز و نصب کن:

```bash
cd extension
gnome-extensions pack --extra-source=default-config.json --extra-source=LICENSE --out-dir=/tmp .
gnome-extensions install /tmp/tuxaliaskit@mehrzadtajkarimi.github.io.shell-extension.zip
```

بعد از نصب، افزونه را در GNOME Extensions فعال کن و صفحهٔ تنظیماتش را باز کن. آیکن ترمینال در پنل GNOME هم میانبر تنظیمات را نشان می‌دهد.

## نصب مستقل Bash

مخزن علاوه بر افزونه، اسکریپت‌های نصب ترمینالی را هم برای کسانی نگه می‌دارد که فقط Aliasها را می‌خواهند:

```bash
bash install.sh
source ~/.bashrc
```

حذف نسخهٔ ترمینالی:

```bash
bash uninstall.sh
```

اگر افزونه و نصب مستقل هر دو فعال باشند ممکن است Aliasهای یکسان دوباره تعریف شوند؛ برای مدیریت گرافیکی، اتصال بخش **Bash** در افزونه را به‌کار ببر.

## مدیریت Aliasها و تابع‌ها

- صفحهٔ **Aliasها** فهرست میانبرها، توضیحات، گروه‌ها و وضعیت فعال‌بودن را نشان می‌دهد. از همین صفحه می‌توان موردی را جست‌وجو، اضافه، ویرایش، غیرفعال یا حذف کرد.
- صفحهٔ **تابع‌ها** برای مدیریت تابع‌هایی مثل `webp_convert` است. بدنهٔ Bash را ویرایش می‌کنی؛ خود تابع فقط هنگام فراخوانی در ترمینال اجرا می‌شود.
- تنظیمات کاربر در `${XDG_CONFIG_HOME:-~/.config}/tux-alias-kit/` ذخیره می‌شوند.
- برای در دسترس بودن در ترمینال، صفحهٔ **اتصال Bash** به‌صورت اختیاری یک بلوک مشخص به `~/.bashrc` اضافه می‌کند؛ پیش از آن نسخهٔ پشتیبان می‌سازد و از کاربر تأیید می‌گیرد. برداشتن اتصال همان بلوک را حذف می‌کند و تنظیمات شخصی را نگه می‌دارد.
- ترمینال‌های باز به‌طور خودکار به‌روز نمی‌شوند. برای بارگذاری دستی اجرا کن:

```bash
source "${XDG_CONFIG_HOME:-$HOME/.config}/tux-alias-kit/generated.sh"
```

## `webp_convert`

این تابع به `cwebp` نیاز دارد:

```bash
webp_convert photo.jpg
webp_convert photo.png 90
webp_convert photo.png result 75
```

کیفیت پیش‌فرض ۸۰ است. خروجی کنار تصویر اصلی با پسوند `.webp` ساخته می‌شود و فایل موجود بازنویسی نمی‌شود.

## وضعیت انتشار در GNOME Extensions

مجوز پروژه `GPL-2.0-or-later` است. مخزن عمومی GitHub `mehrzadtajkarimi/TuxAliasKit` موجود است و `metadata.json` به آن اشاره می‌کند. فقط GNOME Shell 48 در فراداده ثبت شده، چون محیط توسعهٔ فعلی GNOME Shell 48.7 دارد و نسخه‌های دیگر هنوز آزمایش نشده‌اند.

پیش از ارسال واقعی، نگه‌دارندهٔ پروژه باید بتواند کد JavaScript را توضیح دهد، اشکال‌زدایی کند و نگهداری آن را بپذیرد. بستهٔ محلی آمادهٔ بازبینی است؛ انتشار و نمایش در Browse پس از بررسی GNOME انجام می‌شود.

برای ساخت بستهٔ محلی:

```bash
gnome-extensions pack --extra-source=default-config.json --extra-source=LICENSE --out-dir /tmp extension
```

این بستهٔ محلی معادل انتشار عمومی نیست.
