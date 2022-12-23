# Service Metadata

Service metadata reported through ` opensergo. API. V1. MetadataService. ReportMetadata ` method. The input type is `ReportMetadataRequest`, the output type is `ReportMetadataReply`.

Service contract information is defined in 'protobuf' format [service_contract.proto](https://github.com/opensergo/opensergo-proto/blob/main/opensergo/proto/service_contract/v1/service_contract.proto#L26).

#### ReportMetadataRequest

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   app_name   |  string    |  required | name of application |
| 2     |   node   |   Node   |  required | infomation of the node |
| 3     |   service_metadata   |   ServiceMetadata array   |  required | service metadata of application |

#### ReportMetadataReply

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

Currently ReportMetadataReply does not have any field.

#### ServiceMetadata

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   listening_addresses   |  SocketAddress array    |  required | listening address of service |
| 2     |   protocols   |  string array    |  required | supported communication protocols |
| 3     |   service_contract   |  ServiceContract    |  required |  service contract |

#### Notation of communication protocol

In order to clearly express the access mode supported by the service, the overall service access mode is represented by `<communication-protocol>://<ip>:<port>`.

Currently, reserved communication protocols include `http`, `dubbo`, `tri`, `grpc`, and `thrift`.

#### ServiceContract

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   services   |  ServiceDescriptor array    |  required | Included service definitions |
| 2     |   types   |  TypeDescriptor array    |  required | message type definitions used by services |

#### ServiceDescriptor

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  required | service name, must be unique in the application |
| 2     |   methods   |  MethodDescriptor array |    |  required | the method definitions provided by the service |
| 3     |   description  |  string    |  optional | service Description |

#### MethodDescriptor

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  required | method name, must be unique in the service |
| 2     |   input_types   |  string array    |  required | The input type name of the method, the type definition can be found in Servicecontract.types |
| 3     |   output_types   |  string array    |  required | The type name of the method's output argument can be found in servicecontract.types |
| 5     |   client_streaming  |  bool    |  optional | Identifies if client streams multiple client messages |
| 6     |   server_streaming  |  bool    |  optional | Identifies if server streams multiple server messages |
| 7     |   description  |  string    |  optional | description of method |
| 8     |   http_paths  |  string array    |  optional | paths of http |
| 9     |   http_methods  |  string array   |  optional | methos of http |

#### TypeDescriptor

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  required | type name, must be unique in ServiceContract |
|2 | fields | FieldDescriptor array | required | definitions of fields |


#### FieldDescriptor

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   name   |  string    |  required | field name, must be unique in the type |
|3 | number | int32 | required | field number of the field, used for serialization |
|5| type| FieldDescriptor.Type | required | type of field |
|6| type_name | string | optional | when type is TYPE_MESSAGE, type_name is message name |
|7|description|string|optional| description of field |


#### FieldDescriptor.Type

*Field number 1-256 are reserved for future expansion of the OpenSergo protocol*

This type is enum, and represents the type of the field.

| Field number | Field name | Description |
| -------- | -------- | ---- |
|0|TYPE_UNSPECIFIED| default value, indicating that no type is specified|
|1|TYPE_DOUBLE| double|
|2|    TYPE_FLOAT| float|
|3|TYPE_INT64  | int64|
|4| TYPE_UINT64 | uint64|
|5|TYPE_INT32| int32 |
|6| TYPE_FIXED64 | fixed64 |
|7|    TYPE_FIXED32 |fixed32 |
|8| TYPE_BOOL | bool |
|9|  TYPE_STRING | string |
|11|    TYPE_MESSAGE |message, custom compound type |
|12|TYPE_BYTES | bytes |
|13|TYPE_UINT32| uint32 |
|14|TYPE_ENUM | enum |
|15|TYPE_SFIXED32 | sfixed32 |
|16|TYPE_SFIXED64 | sfixed64 |
|17|TYPE_SINT32 | sint32 |
|18|TYPE_SINT64 | sint64 |

#### Node

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   identifier   |  NodeIdentifier    |  required | identify the node |
| 4     |   locality   |  Locality    |  optional | identify the region where a node deployed |
| 5     |   tag   |  string    |  optional | service tag of a node |
| 6     |   cluster   |  string    |  optional | cluster where the node deployed |
| 7     |   env   |  string    |  optional | environment where the node deployed |

#### NodeIdentifier

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   host_name   |  string    |  required | hostname of machine/pod |
| 2     |   pid|uint32   |    required | process id |
| 3     |   start_timestamp|google.protobuf.Timestamp   |    required | start time of the process, the process ID may be reused |

#### SocketAddress

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 1     |   address   |  string    |  required | IP address of the listener, must be IP addresses that are visible outside the machine. 0.0.0.0 and 127.0.0.1 cannot be accessed externally |
| 2     |   port_value|uint32   |    required | port number |

#### Locality

*Field number 1-32 are reserved for future expansion of the OpenSergo protocol*

| Field number | Field name | Type | Optional | Description |
| -------- | -------- | -------- |  ---- | ---- |
| 2     |   region   |  string    |  required | region where the node is deployed |
|3|zone|string|required| zone where the node is deployed |
