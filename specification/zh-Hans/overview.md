# OpenSergo Spec


## 接入方式

对于各个框架，*必须*使用环境变量方式接入服务治理。

有如下两个环境变量：

`OPENSERGO_BOOTSTRAP_CONFIG`
为 JSON 格式的服务治理配置内容，比如：
```json
{
  "endpoint":"opensergo-pilot.opensergo-pilot.svc.cluster.local:50051"
}
```

`OPENSERGO_BOOTSTRAP`
内容为配置文件路径，路径的内容是JSON格式的服务治理配置。


对于框架，如果上述两个环境变量任意一个存在，则开启服务治理功能。
