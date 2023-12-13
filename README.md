# README

### DEMO

![49FADE61-F6A6-4AC0-A664-EA9FBC72077B_1_206_a](https://github.com/syunsuke-I/rails_ec/assets/132537904/8aeae8ec-8a05-4a79-877e-a6e3869561fd)

### 前提

- dockerが必要です。

### setup

```
docker compose build
```

```
docker compose run --rm web bin/setup
```


```
docker compose run --rm web yarn install
```

## run

```
docker compose up
```

http://localhost:3000

### 備考(使用したもの)

## rubocop

auto correct

```
docker compose run --rm web bundle exec rubocop -A
```

## htmlbeautifier


```
docker compose run --rm web bin/htmlbeautifier
```

### ER図

![](img_for_readme/mermaid-diagram-2023-10-16-105935.png)

