# Authentication hook scripts

Скрипты для прохождения DNS ACME Challenge

* Для корректной работы необходимо указывать полный путь до скрипта
* В скриптах стоит время ожидания в 5 минут

## Рег.ру

Скрипт для прохождения проверки на [Рег.ру](https://www.reg.ru/)

* `username` - логин
* `password` - пароль
* `domain` - домен

```sh
sudo certbot certonly --manual --preferred-challenges=dns -d *.<domain> --manual-auth-hook <full_path>/reg-auth.sh --non-interactive
```

## NetAngels

Скрипт для прохождения проверки на [NetAngels](https://www.netangels.ru/)

* `api_key` - ключ API
* `record_id` - можно получить через [Postman](https://www.postman.com/virenbar/netangels-api)
* `domain` - домен

```sh
sudo certbot certonly --manual --preferred-challenges=dns -d *.<domain> --manual-auth-hook <full_path>/net-angels-auth.sh --non-interactive
```
