# whaleai-hbase

## 提供Hbase自动化部署方案，WhaleAI专注人工智能/大数据

>已支持版本 hbase-1.3.1

This script installs hbase  with basic data, log, and pid directories.

> USAGE: ``` . whaleai-hbase.sh [options]```

```
OPTIONS:
   -i, --install　        伪分布式安装部署hbase

   -r, --remove           卸载hbase

   -h, --help             Show this message.
```

EXAMPLES:
  如何安装？hbase install:
```
		 . whaleai-hbase.sh -i　

		 Or . install-hbase.sh --install
```
  如何卸载？hbase remove:

```
		 . whaleai-hbase.sh -r

		 Or . install-hbase.sh --remove
```
