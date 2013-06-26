#### Install and play

git clone git@github.com:the-teacher/em_play.git

bundle

thin start -R ./config.ru -a 0.0.0.0 -p 9999

thin start -R ./config.ru -a 0.0.0.0 -p 9999 --threaded

ab -c 5 -n 20 "0.0.0.0:9999/"
