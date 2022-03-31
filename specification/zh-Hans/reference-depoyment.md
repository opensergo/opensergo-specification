# 参考部署模式

对于常用的Kubernetes环境，可供参考的部署模式如下：

![](./images/overview.png)

## 组件说明

* 治理规则定义

包含了服务治理中基本概念的定义、治理规则的定义。

* [OpenSergo协议](./opensergo-protocol.md)

基于gRPC描述的标准化协议，包含了服务治理中的上报规范、治理规则下发的格式。

* [OpenSergo-pilot](./pilot.md)

负责通过环境变量注入OpenSergo接入信息，接收、转发上报信息、治理规则下发。

* OpenSergo-dashboard

负责接收并存储服务上报信息、展示服务状态、配置服务治理规则。
