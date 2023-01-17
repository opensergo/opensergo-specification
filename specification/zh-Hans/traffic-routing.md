# 流量路由标准 v1alpha1

* domain: traffic
* version: v1alpha1

流量路由，顾名思义就是将具有某些属性特征的流量，路由到指定的目标。流量路由是流量治理中重要的一环，多个路由如同流水线一样，形成一条路由链，从所有的地址表中筛选出最终目的地址集合，再通过负载均衡策略选择访问的地址。开发者可以基于流量路由标准来实现各种场景，如灰度发布、金丝雀发布、容灾路由、标签路由等。

流量路由规则 (`v1alpha1`) 主要分为两部分：

* 流量标签规则 (`TrafficRouter`)：将特定特征的流量映射至特定特征所对应的 VirtualWorkloads 上。
* Workload 集合的抽象 (`VirtualWorkload`)：将某一组工作负载（如 Kubernetes Deployment, Statefulset 或者一组 pod，或某个 JVM 进程，甚至是一组 DB 实例）按照一定的特征进行分类。

OpenSergo 流量路由规则基于 Istio 流量路由规则进行扩展和改写，其中 `TrafficRouter` CRD 基于 [Istio VirtualService](https://istio.io/latest/docs/reference/config/networking/virtual-service) 进行扩展，`VirtualWorkload` CRD 基于 [Istio DestinationRule](https://istio.io/latest/docs/reference/config/networking/destination-rule/) 进行扩展。


## 概念介绍

### 流量路由规则 (TrafficRouter)
流量路由规则（`TrafficRouter`）将特定特征的流量映射至特定特征所对应的 `VirtualWorkload` 上。

假设现在需要将内部测试用户灰度到新版服务，测试用户请求头 tag 为 v2，不符合条件的外部用户流量访问 v1 版本。那么只需要配置如下 CRD 即可：

```yaml
apiVersion: traffic.opensergo.io/v1alpha1
kind: TrafficRouter
metadata:
  name: service-provider
  namespace: default
  labels:
    app: service-provider
spec:
  hosts:
    - service-provider
  http:
    - match:
        - headers:
            tag:
              exact: v2
      route:
        - destination:
            host: service-provider
            subset: v2
            fallback:
              host: service-provider
              subset: v1
    - route:
        - destination:
            host: service-provider
            subset: v1
```

这条`TrafficRouter`规则指定了一条最简单的流量路由规则，将请求头 tag 为 v2 的 HTTP 请求路由到 v2 版本，其余的流量都路由到 v1 版本。如果 v2 版本没有对应的节点，则将流量 fallback 至 v1 版本。

`TrafficRouter` 规则已经在 OpenSergo 控制面以及 [Spring Cloud Alibaba](https://github.com/alibaba/spring-cloud-alibaba/blob/2.2.x/spring-cloud-alibaba-examples/governance-example/label-routing-example/readme-zh.md#%E9%9B%86%E6%88%90opensergo) 中实现。

#### TrafficRouter
目前 TrafficRouter 主要基于 [Istio VirtualService](https://istio.io/latest/docs/reference/config/networking/virtual-service) 进行扩展，在 [destination](https://istio.io/latest/docs/reference/config/networking/virtual-service/#Destination) 中新增了 fallback 字段用于配置选中的 subset 实例列表为空时的备选路由 subset。

增强后的 VirtualService destination 配置：

| Field |	Type | Description | Required |
| --------| -------- | -------- | -------- |
| host |  string | The name of a service from the service registry. Service names are looked up from the platform’s service registry (e.g., Kubernetes services, Consul services, etc.) and from the hosts declared by [ServiceEntry](https://istio.io/latest/docs/reference/config/networking/service-entry/#ServiceEntry). |  Yes  | 
| subset |  string | The name of a subset within the service. Applicable only to services within the mesh. The subset must be defined in a corresponding DestinationRule. |  No  | 
| port |  [PortSelector](https://istio.io/latest/docs/reference/config/networking/virtual-service/#PortSelector) | Specifies the port on the host that is being addressed. If a service exposes only a single port it is not required to explicitly select the port.|  No  | 
| fallback |  Fallback | If the subset in the routing result is empty, then the fallback subset can be selected. |  No  | 


#### Fallback

| Field |	Type | Description | Required |
| --------| -------- | -------- | -------- |
| host |  string | The name of the fallback service from the service registry. |  Yes  | 
| subset |  string | The name of a subset within the fallback service.  |  No  | 


## Workload 的抽象 (`VirtualWorkload`)
`VirtualWorkload` 虚拟工作负载即 workload 集合的抽象，将一定属性特征的 workload 集合划分成一个 VirtualWorkload，其中 VirtualWorkload 可以是目标 service 集合也可以是 deployment，甚至可以是 database 的实例、库、表集合。

`VirtualWorkload` 规则目前 OpenSergo 社区还在落地实现中，欢迎感兴趣的同学参与。
