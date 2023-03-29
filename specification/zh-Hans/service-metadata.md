# 服务元数据

服务元数据协议：对于服务而言，需要上报服务契约信息，用于进行服务调试、服务路由等服务治理场景；以及心跳信息，用于确保服务元数据的时效性。

服务元数据的上报通过 `MetadataService#ReportMetadata` 方法上报实现，入参为 `ReportMetadataRequest`，出参为 `ReportMetadataReply`。

具体的服务契约信息以 `protobuf` 格式定义 [service_contract.proto](https://github.com/opensergo/opensergo-proto/blob/main/opensergo/proto/service_contract/v1/service_contract.proto)。

## 服务元数据请求/ReportMetadataRequest

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   app_name   |  string    |  必选 | 唯一应用名字 |
| 2     |   node   |   Node   |  必选 | 该节点的信息 |
| 3     |   service_metadata   |   `ServiceMetadata` 数组   |  必选 | 服务元信息 |

## 服务元数据响应/ReportMetadataReply

*字段id 1-32为OpenSergo协议预留，供未来扩展*

目前 ReportMetadataReply 没有任何字段。

## 服务元信息/ServiceMetadata

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   listening_addresses   |  SocketAddress数组    |  必选 | 服务监听的地址 |
| 2     |   protocols   |  string数组    |  必选 | 服务支持的通信协议 ，见[通信协议表示](#通信协议表示)|
| 3     |   service_contract   |  ServiceContract    |  必选 |  服务契约信息 |

### 通信协议的表示法

为了能够清晰的表示服务支持的访问方式，整体的服务访问方式采用`<通信协议>://<ip>:<port>`表示。
目前约定的通信协议包括 `http`、`dubbo`、`tri`、`grpc`、`thrift` 。

### 服务信息/ServiceContract

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   services   |  ServiceDescriptor数组    |  必选 | 包含的服务定义 |
| 2     |   types   |  TypeDescriptor数组    |  必选 | 包含服务使用到的消息类型定义 |

### 服务定义信息/ServiceDescriptor

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  必选 | 服务名字，在应用中唯一 |
| 2     |   methods   |  MethodDescriptor数组    |  必选 | 包含服务提供的方法定义 |
| 3     |   description  |  string    |  可选 | 包含服务的业务描述信息 |

### 方法定义信息/MethodDescriptor

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  必选 | 方法名字，在服务中唯一 |
| 2     |   input_types   |  string数组    |  必选 | 方法的入参类型名，可以在ServiceContract.types中找到类型定义 |
| 3     |   output_types   |  string数组    |  必选 | 方法的出参类型名，可以在ServiceContract.types中找到类型定义 |
| 5     |   client_streaming  |  bool    |  可选 | 客户端是否流式发送数据 |
| 6     |   server_streaming  |  bool    |  可选 | 服务端是否流式发送数据 |
| 7     |   description  |  string    |  可选 | 方法的业务描述 |
| 8     |   http_paths  |  string数组    |  可选 | 表示http方法的path |
| 9     |   http_methods  |  string数组   |  可选 | 支持的http请求方法 |

### 类型定义信息/TypeDescriptor

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  必选 | 类型名字，在整个服务契约中必须唯一 |
|2 | fields | FieldDescriptor数组 | 必选 | 各个字段的定义 |


### 字段定义信息/FieldDescriptor

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  必选 | 字段名字，在当前类型中必须唯一 |
|3 | number | int32 | 必选 | 当前字段的字段id，序列化时使用 |
|5| type| FieldDescriptor.Type | 必选 | 当前字段的类型 |
|6| type_name | string | 可选 | 当字段类型是 TYPE_MESSAGE 时，表示类型的全名 |
|7|description|string|可选|字段的描述信息|

### 字段类型/FieldDescriptor.Type

*字段id 1-256为OpenSergo协议预留，供未来扩展*

此类型为枚举，表示字段的类型。随着接入rpc框架的扩展，类型会扩充。


| 字段id | 字段名 |  描述 |
| -------- | -------- | ---- |
|0|TYPE_UNSPECIFIED| 默认值，表示没有指定类型|
|1|TYPE_DOUBLE| double类型|
|2|    TYPE_FLOAT| float类型|
|3|TYPE_INT64  | int64类型|
|4| TYPE_UINT64 | uint64类型|
|5|TYPE_INT32|int32类型|
|6| TYPE_FIXED64 | fixed64类型|
|7|    TYPE_FIXED32 |fixed32类型|
|8| TYPE_BOOL | bool 类型|
|9|  TYPE_STRING | string类型|
|11|    TYPE_MESSAGE |message类型，表示是自定义的复合类型|
|12|TYPE_BYTES |bytes类型，表示字节数组|
|13|TYPE_UINT32| uint32类型 |
|14|TYPE_ENUM | 枚举类型|
|15|TYPE_SFIXED32 | sfixed32类型，32位定长数值|
|16|TYPE_SFIXED64 | sfixed64类型，64位定长数值|
|17|TYPE_SINT32 | sint32类型 |
|18|TYPE_SINT64 | sint64类型 |

### 节点信息/Node

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   identifier   |  NodeIdentifier    |  必选 | 节点和进程的唯一定位标志 |
| 4     |   locality   |  Locality    |  可选 | 标志节点的所在区域信息 |
| 5     |   tag   |  string    |  可选 | 节点的业务标签 |
| 6     |   cluster   |  string    |  可选 | 节点所在的集群 |
| 7     |   env   |  string    |  可选 | 节点所在的环境 |

### 节点标识信息/NodeIdentifier

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   host_name   |  string    |  必选 | 节点所在的主机名 |
| 2     |   pid|uint32   |    必选 | 进程id |
| 3     |   start_timestamp|google.protobuf.Timestamp   |    必选 | 进程启动的时间，因为进程id有可能会重用，所以需要加上进程启动时间来唯一标识 |

### 监听地址信息/SocketAddress

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   address   |  string    |  必选 | 监听的ip地址。必须使用机器外可见的ip地址，0.0.0.0和127.0.0.1不能被外部访问 |
| 2     |   port_value|uint32   |    必选 | 监听的端口号 |

### 节点位置信息/Locality

*字段id 1-32为OpenSergo协议预留，供未来扩展*

| 字段id | 字段名 | 类型 | 必选/可选 | 描述 |
| -------- | -------- | -------- |  ---- | ---- |
| 2     |   region   |  string    |  必选 | 节点所部署的region |
|3|zone|string|必选|节点所部署的可用区|

