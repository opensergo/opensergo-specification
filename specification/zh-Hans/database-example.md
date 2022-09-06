# 数据库治理示例

## 读写分离

静态读写分离配置示例：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: readwrite_splitting_db
spec:
  services:
  - name: readwrite_splitting_db
    databaseMySQL:
      db: readwrite_splitting_db
      host: localhost
      port: 3306
      user: root
      password: root
    readWriteSplitting: "readwrite"  # 声明所需要的读写分离策略
---
# 写数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: write_ds
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_write_ds?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 第一个读数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: read_ds_0
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_read_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第二个读数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: read_ds_1
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_read_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 静态读写分离配置
apiVersion: database.opensergo.io/v1alpha1
kind: ReadWriteSplitting
metadata:
  name: readwrite
spec:
  rules:
    staticStrategy:
      writeDataSourceName: "write_ds"
      readDataSourceNames: 
      - "read_ds_0"
      - "read_ds_1"
      loadBalancerName: "random"
    loadBalancers:
    - loadBalancerName: "random"
      type: "RANDOM"
```

动态读写分离配置：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: readwrite_splitting_db
spec:
  services:
  - name: readwrite_splitting_db
    databaseMySQL:
      db: readwrite_splitting_db
      host: localhost
      port: 3306
      user: root
      password: root
    readWriteSplitting: "readwrite"  # 声明所需要的读写分离策略
---
# 第一个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_0
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_primary_ds?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 第二个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_1
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_replica_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第三个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_2
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_replica_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 动态读写分离配置
apiVersion: database.opensergo.io/v1alpha1
kind: ReadWriteSplitting
metadata:
  name: readwrite
spec:
  rules:
    dynamicStrategy:
      autoAwareDataSourceName: "readwrite_ds"
      writeDataSourceQueryEnabled: true
      loadBalancerName: "random"
    loadBalancers:
    - loadBalancerName: "random"
      type: "RANDOM"
---
# 数据库发现配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseDiscovery
metadata:
  name: "readwrite_ds"
spec:
  dataSources:  
    readwrite_ds:         
      dataSourceNames:
      - ds_0
      - ds_1
      - ds_2
    discoveryHeartbeatName: mgr-heartbeat
    discoveryTypeName: mgr
  discoveryHeartbeats:      # 数据库发现探测心跳
    mgr-heartbeat:
      props:
        "keep-alive-cron": '0/5 * * * * ?'
  discoveryTypes:          # 数据库发现类型
    mgr:
      type: MySQL.MGR
      props:
        "group-name": 92504d5b-6dec-11e8-91ea-246e9612aaf1
```

## 分库分表

分库分表示例：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: sharding_db
spec:
  services:
  - name: sharding_db
    databaseMySQL:
      db: sharding_db
      host: localhost
      port: 3306
      user: root
      password: root
    sharding: "sharding_db"  # 声明所需要的分库分表策略
---
# 第一个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_0
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第二个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_1
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 分库分表配置
apiVersion: database.opensergo.io/v1alpha1
kind: Sharding
metadata:
  name: sharding_db
spec:
  tables: # map[string]object 类型
    t_order:
      actualDataNodes: "ds_${0..1}.t_order_${0..1}"
      tableStrategy:
        standard:
          shardingColumn: "order_id"
          shardingAlgorithmName: "t_order_inline"
      keyGenerateStrategy:
        column: "order_id"
        keyGeneratorName: "snowflake"
    t_order_item:
      actualDataNodes: "ds_${0..1}.t_order_item_${0..1}"
      tableStrategy:
        standard:
          shardingColumn: "order_id"
          shardingAlgorithmName: "t_order_item_inline"
      keyGenerateStrategy:
        column: order_item_id
        keyGeneratorName: snowflake
  bindingTables:
  - "t_order,t_order_item"
  defaultDatabaseStrategy:
    standard:
     shardingColumn: "user_id"
     shardingAlgorithmName: "database_inline"
  # defaultTableStrategy: # 为空表示 none
  shardingAlgorithms: # map[string]object 类型
    database_inline:
      type: INLINE    
      props: # map[string]string 类型
        algorithm-expression: "ds_${user_id % 2}"
    t_order_inline:  
      type: INLINE    
      props:
        algorithm-expression: "d_order_${order_id % 2}"      
    t_order_item_inline:
      type: INLINE    
      props:
        algorithm-expression: "d_order_item_${order_id % 2}"
  keyGenerators: # map[string]object 类型
    snowflake:
      type: SNOWFLAKE
```

如果需要开启分布式事务，需要提供如下配置：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: readwrite_splitting_db
spec:
  services:
  - name: readwrite_splitting_db
    databaseMySQL:
      db: readwrite_splitting_db
      host: localhost
      port: 3306
      user: root
      password: root
    sharding: "sharding_db"  # 声明所需要的分库分表策略
    distributedTransaction: "sharding_db_txn" # 声明所需要的分布式事务配置
---
# 第一个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_0
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第二个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_1
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 分库分表配置
apiVersion: database.opensergo.io/v1alpha1
kind: Sharding
metadata:
  name: sharding_db
spec:
  tables: # map[string]object 类型
    t_order:
      actualDataNodes: "ds_${0..1}.t_order_${0..1}"
      tableStrategy:
        standard:
          shardingColumn: "order_id"
          shardingAlgorithmName: "t_order_inline"
      keyGenerateStrategy:
        column: "order_id"
        keyGeneratorName: "snowflake"
    t_order_item:
      actualDataNodes: "ds_${0..1}.t_order_item_${0..1}"
      tableStrategy:
        standard:
          shardingColumn: "order_id"
          shardingAlgorithmName: "t_order_item_inline"
      keyGenerateStrategy:
        column: order_item_id
        keyGeneratorName: snowflake
  bindingTables:
  - "t_order,t_order_item"
  defaultDatabaseStrategy:
    standard:
     shardingColumn: "user_id"
     shardingAlgorithmName: "database_inline"
  # defaultTableStrategy: # 为空表示 none
  shardingAlgorithms: # map[string]object 类型
    database_inline:
      type: INLINE    
      props: # map[string]string 类型
        algorithm-expression: "ds_${user_id % 2}"
    t_order_inline:  
      type: INLINE    
      props:
        algorithm-expression: "d_order_${order_id % 2}"      
    t_order_item_inline:
      type: INLINE    
      props:
        algorithm-expression: "d_order_item_${order_id % 2}"
  keyGenerators: # map[string]object 类型
    snowflake:
      type: SNOWFLAKE
---
apiVersion: database.opensergo.io/v1alpha1
kind: DistributedTransaction
metadata:
  name: sharding_db_txn
spec:
  transaction:
    defaultType: "base"
    providerType: "Seata"
```

## 加密

加密示例：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: encrypt_db
spec:
  services:
  - name: encrypt_db
    databaseMySQL:
      db: encrypt_db
      host: localhost
      port: 3306
      user: root
      password: root
    encryption: "encrypt_db"  # 声明所需要的加密策略
---
# 第一个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_0
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第二个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds_1
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
apiVersion: database.opensergo.io/v1alpha1
kind: Encryption
metadata:
  name: encrypt-db
spec:
  encryptors:  # map[string]object 类型
    aes_encryptor:  # 加密算法名称
      type: AES
      props:
        "aes-key-value": "123456abc"
    md5_encryptor:  # 加密算法名称
      type: "MD5"
  tables: # map[string]object 类型
    t_encrypt:      # 加密表名称
      columns: # map[string]object 类型
        user_id:    # 加密列名称
          plainColumn: "user_plain"      # 原文列名称
          cipherColumn: "user_cipher"    # 密文列名称
          encryptorName: "aes_encryptor" # 加密算法名称
          assistedQueryColumn: "" # 查询辅助列名称
        order_id:   # 加密列名称
          cipherColumn: "order_cipher"
          encryptorName: "md5_encryptor"
```

## 影子库

影子库示例：

```yaml
# 虚拟数据库配置
apiVersion: database.opensergo.io/v1alpha1
kind: VirtualDatabasemetadata:
  name: shadow_db
spec:
  services:
  - name: shadow_db
    databaseMySQL:
      db: shadow_db
      host: localhost
      port: 3306
      user: root
      password: root
    shadow: "shadow_db"  # 声明所需要的影子库策略
---
# 第一个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: ds
spec:
  database:
    MySQL:                 # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_0?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1      
---
# 第二个数据源的数据库端点配置
apiVersion: database.opensergo.io/v1alpha1
kind: DatabaseEndpoint
metadata:
  name: shadow_ds
spec:
  database:
    MySQL:                              # 声明后端数据源的类型及相关信息
      url: jdbc:mysql://192.168.1.110:3306/demo_ds_1?serverTimezone=UTC&useSSL=false
      username: root
      password: root
      connectionTimeout: 30000
      idleTimeoutMilliseconds: 60000
      maxLifetimeMilliseconds: 1800000
      maxPoolSize: 50
      minPoolSize: 1
---
# 声明影子库配置
apiVersion: database.opensergo.io/v1alpha1
kind: Shadow
metadata:
  name: shadow-db
spec:
  dataSources:
    shadowDataSource:   
      sourceDataSourceName: "ds"          # 指定源数据源
      shadowDataSourceName: "shadow_ds"   # 指定影子数据源
  tables:                                 # map[string]object 类型
    t_order:                              # 表名
      dataSourceNames:                    # 数据源名称
      - "shadowDataSource"
      shadowAlgorithmNames:               # 影子算法名称
      - "user-id-insert-match-algorithm"
      - "user-id-select-match-algorithm"
    t_order_item:
      dataSourceNames:
      - "shadowDataSource"
      shadowAlgorithmNames:
      - "user-id-insert-match-algorithm"
      - "user-id-update-match-algorithm"
      - "user-id-select-match-algorithm"
    t_address:
      dataSourceNames:
      - "shadowDataSource"
      shadowAlgorithmNames:
      - "user-id-insert-match-algorithm"
      - "user-id-select-match-algorithm"
      - "simple-hint-algorithm"
  shadowAlgorithms:                        # map[string]object 类型
    user-id-insert-match-algorithm:
      type: REGEX_MATCH
      props:
        operation: "insert"
        column: "user_id"
        regex: "[1]"
    user-id-update-match-algorithm:
      type: REGEX_MATCH
      props:
        operation: "update"
        column: "user_id"
        regex: "[1]"    
    user-id-select-match-algorithm:
      type: REGEX_MATCH
      props:
        operation: "select"
        column: "user_id"
        regex: "[1]"
    simple-hint-algorithm:
      type: "SIMPLE_HINT"
      props:
        foo: "bar"
```

