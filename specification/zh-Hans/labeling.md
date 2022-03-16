# 打标

在服务治理中，要根据业务属性来给机器或者流量打标。


## 机器打标

机器的打标通过在注册中心中，给对应的Node添加元数据来打标：

Key为`OpensergoLabel`，Value为标签的名字。

*比如，可以给机器打上v1.0和v2.0的版本标签。*

## 流量打标

流量的标签，可以通过给流量注入额外的、不影响正常业务逻辑的信息（比如OpenTelemetry的Baggage）来实现。

对于RPC请求，添加Key为`OpensergoLabel`，Value为标签的名字的Baggage。

对于其他支持Baggage的协议，也是使用如上方式接入。

*比如，可以给某些客户的请求打上internal的标签。*
