# INFO: Locale & Timezone settings

{ lib, ... }: {
  # Locale
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "ru_RU.UTF-8";
    };
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  # Timezone
  time = {
    timeZone = lib.mkDefault "Europe/Moscow";
  };
}
