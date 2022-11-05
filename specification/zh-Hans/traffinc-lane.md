# 流量染色标准 v1alpha1

* domain: traffic
* version: v1alpha1

假设我们标记了部署新版本代码的节点为 Gray 标签节点，我们希望通过流量路由能力将灰度的流量路由至灰度节点上，即带有 Gray 标签的节点。在这之前我们需要对流量进行打标并将对应的标签在流量中传递，这一块的能力我们称之为流量染色。

![image](https://user-images.githubusercontent.com/43985911/200102288-6b2464e1-2e58-4f0c-83cd-4f6d817d2ebe.png)

流量染色，顾名思义将我们的请求流量进行颜色标记，并且将标记跟随着链路一直传递下去。结合流量路由与流量染色能力，我们可以实现全链路灰度、多环境隔离等场景，实现“流量泳道”的能力。流量染色的场景非常多，以下我总结几个常见的场景。

## 流量染色

### 对经过机器的流量进行染色

![image](https://user-images.githubusercontent.com/43985911/200101663-6f40c2c3-c0dc-4232-87f5-87cec7d92a6b.png)

在这个场景中，流量根据请求特征在分流后，进入到后端的微服务应用。如果经过的是带有 Gray 标签的微服务，那么就会在请求的头部带上 x-opensergo-traffic: Gray 的标记，标识该流量为灰度流量，标记会随着请求调用一直传递下去。

### 通过增加指定的Header进行染色

![image](https://user-images.githubusercontent.com/43985911/200101678-29bb26eb-6eed-4b33-9f18-0233296b11a6.png)

在这个场景中，流量进入微服务之前一般有一个 API 网关（比如，Nginx），也可以是任意的微服务应用，我们称之为入口应用。通常入口应用可以根据流量的特征，在转发收到的请求前先加上额外的头 x-opensergo-traffic: Gray ，标识该流量为灰度流量，入口应用会将灰度流量转发至后端的灰度微服务应用。

### 通过流量规则匹配进行染色

![image](https://user-images.githubusercontent.com/43985911/200101693-9b02f438-469b-4ddf-8bd4-688622cb3323.png)

这一场景就是入口网关根据流量匹配规则对流量条件进行识别匹配，识别出相应流量后加上名为 x-opensergo-traffic的请求头。与场景一的区别就是一个是按照经过应用的节点特征进行打标，一个是根据流量特征与流量匹配规则进行打标。

流量路由能力就会根据请求头中的标记值，将流量路由至对应带有 Gray 标记的节点上，从而实现经过Gray节点的流量在 Gray 泳道中流转的场景。

## 流量标识透传

当流入的流量打上了相应的标签后，如何保证灰度标识能够在链路中一直传递下去呢？如果在请求源头染色，那么请求经过网关时，网关作为代理会将请求原封不动的转发给入口服务，除非开发者在网关的路由策略中实施请求内容修改策略。接着，请求流量会从入口服务开始调用下一个微服务，会根据业务代码逻辑形成新的调用请求，那么我们如何将灰度标识添加到这个新的调用请求，从而可以在链路中传递下去呢？

从单体架构演进到分布式微服务架构，服务之间调用从同一个线程中方法调用变为从本地进程的服务调用远端进程中服务，并且远端服务可能以多副本形式部署，以至于一条请求流经的节点是不可预知的、不确定的，而且其中每一跳的调用都有可能因为网络故障或服务故障而出错。分布式链路追踪技术对大型分布式系统中请求调用链路进行详细记录，核心思想就是通过一个全局唯一的traceid和每一条的spanid来记录请求链路所经过的节点以及请求耗时，其中traceid是需要整个链路传递的。

借助于分布式链路追踪思想，我们采用的方案是结合链路追踪技术（比如，OpenTracing）去解决。链路追踪技术是通过 traceId 去唯一标识一条调用链树，为根请求分配并带上全局唯一的 traceId 后，之后由其所分叉出的所有新调用都得带上值完全一样的 HTTP 头。借此，我们还可以在 TracId 模型的 baggage 中传递一些自定义信息，比如灰度标识。业界常见的分布式链路追踪产品都支持链路传递用户自定义的数据，其数据处理流程如下图所示：

![image](https://user-images.githubusercontent.com/43985911/200101710-01b51088-3852-4da5-b3e5-be9c1c0ea70d.png)

# 流量标识与流量染色 Spec

我们在 OpenSergo 流量路由标准v1alpha1的基础上，新增了 `TrafficLane` 这个 CRD。
这个 CRD 的设计思路包括几部分：匹配条件（for what kind of traffic）、打的标（which tag）、标怎么透传（how to carry the tag between services）

```yaml
apiVersion: traffic.opensergo.io/v1alpha1

kind: TrafficLane
metadata:
  name: tag-traffic-lane-rule
spec:
  selector:
    app: spring-cloud-a
  rules:
    traffic:
      http:
        headers: 
          - X-User-Id:   # 参数名
            exact: 12345       # 参数值
        uri:
          exact: "/index"
  	workload:
       selector:
        tag: gray
    lane:
      name: Gray
    traceIdBaggage: x-opensergo-traffic
```

以上说明了如何使用 TrafficLane 这一 CR 给我们应用指定流量进行染色的方法。其中定义了如何对流量进行打标比如我们对headers中带有X-User-Id为12345、uri为/index的http流量进行Gray的标记，也可以按照节点的标签进行标记（经过Gray的workload的流量染色为Gray），同时定义了名为 x-opensergo-traffic 的 traceIdBaggage，会放在 TraceId 的 Baggage 中存放 Gray 的流量标识。