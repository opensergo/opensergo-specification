# OpenSergo Spec

OpenSergo 致力于构建一套开放的、语言无关的、贴近业务语义的服务治理规范。

让开发者能够以一种统一的规范来管理不同语言、不同协议的服务。

## 背景

不同语言、不同协议的服务，对于自己的能力和模型都有不同的抽象。OpenSergo规范会规定各个微服务应用如何将服务信息上报到管控端、如何从管控端拉取、监听服务治理信息。

## 接入方式

对于各个框架，需要知道向何处上报、从何处拉取、监听服务治理配置。

所以，各个框架**必须**使用环境变量方式接入服务治理。

规定如下两个环境变量：

1. key为`OPENSERGO_BOOTSTRAP_CONFIG`，
  value为 JSON 格式的服务治理配置内容，比如：

  ```json
  {
    "endpoint":"opensergo-pilot.opensergo-pilot.svc.cluster.local:50051"
  }
  ```

2. key为`OPENSERGO_BOOTSTRAP`，value为配置文件路径，路径指向的文件内容是JSON格式的服务治理配置。

对于RPC框架，如果上述两个环境变量任意一个存在，则开启服务治理功能。

## OpenSergo 协议

对于服务而言，需要上报服务契约信息和心跳信息。

由于需要服务治理，也需要下发、监听服务治理的配置信息。

OpenSergo 协议规定了如何上报、下发、监听服务治理信息。

### 通信协议

服务信息的上报和配置的下发、监听都基于gRPC协议来实现。

### 服务契约

服务契约封装了每个应用的如下信息：

* 节点元数据
  * 节点的IP
  * 节点的端口
  * 节点所在的可用区
  * 节点的业务标签
* 服务信息
  * 当前应用提供了哪些服务、哪些方法
  * 当前应用使用了哪些类型，以及类型定义信息

服务契约的上报通过`opensergo.api.v1.MetadataService.ReportMetadata`方法上报实现。

具体的服务契约信息以protobuf格式定义 [service_contract.proto](https://github.com/opensergo/opensergo-proto/blob/main/opensergo/proto/service_contract/v1/service_contract.proto#L26)。

### 服务治理配置

服务治理规则的定义

TBD

## 附录

[参考部署模式](./reference-depoyment.md)
