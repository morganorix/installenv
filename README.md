# installenv
This is a graphical installation with multiple choices for configuring an optimal ssh environment.

(Works on Debian or rapsaberry)

Connect to new environnment linux via ssh.

Copy directory folder **env/** in your user profile **~/**.
```
➜ ~/ git clone git@github.com:morganorix/installenv.git
```

Run the **install.sh** file and follow the procedure.

Use example
```
➜ ~/ bash env/install.sh
```
Or
```
➜ ~/ ./env/install.sh
```

If docker is installed a new alias is configured.

#### dcps

It's a docker compose ps more pretty and lisible
```
➜ ~/ dcps
───────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ STDIN
───────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ CONTAINER ID   |     NAMES   |     IMAGE                 |     CREATED       |     STATUS
   2   │ 57af5070bfce   |     kuma    |     elestio/uptime-kuma   |     6 hours ago   |     Up 6 hours
   3   │ 914814294e31   |     ntfy    |     binwiederhier/ntfy    |     6 hours ago   |     Up 6 hours
───────┴──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

```

#### dcip

As dcps, it display more pretty and lisible ips and ports by conteners.
```
➜ ~/ dcip
```

#### cat

It's a cat more pretty and lisible
```
➜ ~/ cat .bash
```


