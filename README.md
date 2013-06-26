thin start -R ./config.ru -a 0.0.0.0 -p 9999
thin start -R ./config.ru -a 0.0.0.0 -p 9999 --threaded

ab -c 5 -n 20 "0.0.0.0:9999/"
