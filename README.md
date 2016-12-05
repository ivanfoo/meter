# meter  
[![meterDemo](https://s13.postimg.org/8f2x6hmxj/Selection_016.png)](https://postimg.org/image/yamnpoor7/)

A basic app to show simple metrics about a nginx server:
- total get requests
- total post requests
- requests in the last 24 hours
- total requests

### Install

```bundle install```

### Run

```rackup -p 3000 -D```

Also, you can run it behind a web proxy, placing it under `/var/www/meter`:   

```thin start -C /var/www/meter/thin/config.yml```
