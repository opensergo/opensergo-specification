# 打标

在服务治理中，要根据业务属性来给机器或者流量打标。


## 机器打标

机器的打标通过在注册中心中，给对应的Node添加元数据来打标：

Key为`Opensergo-Label`，Value为标签的名字。

*比如，可以给机器打上v1.0和v2.0的版本标签。*

## 流量打标

流量的标签，可以通过给流量注入额外的、不影响正常业务逻辑的信息来实现。

对于Http请求，添加Key为`Opensergo-Label`，Value为标签的名字的Header。

对于gRPC请求，可以添加Key为`Opensergo-Label`，Value为标签的名字的[Metadata](https://grpc.io/docs/what-is-grpc/core-concepts/#metadata)。

*比如，可以给某些客户的请求打上internal的标签。*
