# OpenSergo-Pilot

OpenSergo-Pilot主要接收来自业务进程的连接，并将这些连接中的信息对接到对应的厂商后端。

OpenSergo-Pilot主要有三个功能：

## 注入OpenSergo接入信息

对于Kubernetes容器化部署的方式，pilot可以通过webhook给容器注入OpenSergo接入信息。

给Pod增加环境变量，key为`OPENSERGO_BOOTSTRAP_CONFIG`，value为 JSON 格式的服务治理配置内容，比如：

```json
{
  "endpoint":"opensergo-pilot.opensergo-pilot.svc.cluster.local:50051"
}
```

## 转发上报信息

由于上报的服务契约、心跳信息灵活多变，且有检索需求，所以上报给dashbaord及其存储。

所有的接入进程都会上报契约信息、心跳信息到pilot，pilot会将此部分数据转发到dashboard。

## 服务治理规则下发

pilot监听服务治理的CR变化，并将这些变化通知到所有的接入业务进程，从而治理业务流量。
