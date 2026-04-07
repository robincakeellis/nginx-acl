# nginx-acl

Generator of NGINX ACL IPv4/IPv6 non map (allow/deny) rules, and map-based IPv4-only rules for an autonomous system number (ASN).

This project is cloned from https://github.com/zarplata/nginx-acl

## Installation

```
git clone https://github.com/robincakeellis/nginx-acl.git
```

## Dependent binaries

* jq
* curl
* xargs

## Creating non map rules including IPv6

Allow AS14061 (Digital Ocean).
```
nginx-acl.sh allow 14061 > /etc/nginx/config/allow/digital-ocean.conf
```

Deny AS14061 (Digital Ocean).
```
nginx-acl.sh deny 14061 > /etc/nginx/config/deny/digital-ocean.conf
```

## Creating IPv4 list for map-based rules.

Allow AS135377 (UCLOUD).
```
nginx-acl-map.sh 0 135377 > /etc/nginx/snippets/ucloud.conf
```

Deny AS135377 (UCLOUD).
```
nginx-acl-map.sh 1 135377 > /etc/nginx/snippets/ucloud.conf
```

## Map usage in nginx configuration

### Example nginx.conf

```
...
        geo $blocked_ip {
                default 0;
                include /etc/nginx/snippets/ucloud.conf;
        }
...        
```

### In a server or location

```
...
        if ($blocked_ip = 1) {
            return 403; # or some other code
        }
...
```
