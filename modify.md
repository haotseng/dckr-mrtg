
## docker image

原作者的 [docker image](https://hub.docker.com/r/fboaventura/dckr-mrtg) 會無法產生 DrayTek 2952 router 的 mrtg 檔案.
因此我修改了 docker image 的 source code. 並重新產生 docker image. 
[原作的 source 在這](https://github.com/fboaventura/dckr-mrtg), [我修改過的在這](https://github.com/haotseng/dckr-mrtg).

## 執行方式

1. 首先修改 docker-compose.yml, 將 REGENERATEHTML 設成 "yes". 第一次執行docker 之後, 會產生 conf.d 以及 html 目錄.
然後就可以將 REGENERATEHTML 設成 "no". 下次重啟docker 時, 就不會蓋掉舊資料了

2. 還有就是關於timezone 的設定. 我移除了原作說明文件的 `/etc/localtime` 以及 `/etc/timezone` 的設定. 這個設定會造成 `timezone` 失效. 

下面是我的 `docker-compose.yml` 檔內容. 


    version: "3.5"
    
    services:
      mrtg:
        image: haostudio/dckr-mrtg:2.5.3-dev
        container_name: mrtg
        hostname: mrtg
        restart: always
        ports:
          - "8880:80"
        volumes:
          - "./conf.d:/etc/mrtg/conf.d"
          - "./html:/mrtg/html"
          #- "/etc/localtime:/etc/localtime:ro"
          #- "/etc/timezone:/etc/timezone:ro"
        environment:
            TZ: "Asia/Taipei"
            HOSTS: "public:192.168.192.242,public:192.168.192.238,public:192.168.192.253,public:192.168.192.254,public:192.168.192.1,public:192.168.18.248,public:192.168.18.251,public:192.168.18.250,public:192.168.18.254"
            WEBDIR: "/mrtg/html"
            REGENERATEHTML: "yes"
            #REGENERATEHTML: "no"
            USERID: 1000
            GROUPID: 1000
        tmpfs:
          - "/run"



