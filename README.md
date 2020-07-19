# Taro
## 初期設定
```
$ git clone git@github.com:IshimotoTakara/reportoken_backend.git
$ cd reportoken_backend

## Docker環境を使う場合
```
~/reportoken_backend $ docker-compose build
~/reportoken_backend $ docker-compose run web rake db:create
~/reportoken_backend $ docker-compose up

# 新しくGemを追加した場合、buildし直す
~/reportoken_backend $ docker-compose build
```

## その他