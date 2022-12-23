# OpenSergo Specification

[中文版本]

OpenSergo is an open, language-agnostic, and cloud-native service governance specification that is close to business semantics.
In the scenario of heterogeneous microservice system, enterprises can manage services in different languages and protocols with this unified specification. 

## Glossary

* Application - Represents a microservice, typically standalone deployed, that may provide one or more services for the provider to invoke.
* Service - A collection of interfaces with explicit business semantics that can be invoked by consumers, usually containing one or more interfaces.
* Interface - Used to represent an identified interface, usually with an explicit interface description, call parameter definition, and return value definition.
* Node - Indicates the hardware resource where an application is deployed. Multiple nodes can form a cluster.
* Cluster - A cluster defines a group of nodes where an application is deployed, for example, a K8S cluster. A group of virtual machines can also form a cluster.
* Environment - The combination of a set of resources on which an application is deployed and run. Common environment definitions include test, daily, staging, and production. An environment can contain multiple clusters.
* Tag - An application can be composed of multiple nodes. The nodes of the same application can be divided into different groups according to their functions. The nodes that meet certain conditions can be selected through tags.

## Background

Micro-services frameworks with different language, different communication protocol,  has a different abstraction for their own ability and the model. For example, some framework use interface level service registration and discovery, some framework use  application level service registration and discovery. As a result, it is difficult to connect and manage heterogeneous microservice systems in a unified management system.

`OpenSergo`  try to solve this problem by standardizing concepts, defining microservice components, service registration discovery, service metadata format, service observability and other basic capabilities to open up the application of various microservice frameworks. At the same time, through protocol standardization, the communication protocol between data plane and control plane is clarified, and the standard format of service governance rules is determined, so as to realize unified governance of heterogeneous microservice system.

## Scope of OpenSergo

* Service registration discovery: Define service registration and discovery capabilities between services so that heterogeneous microservices can be interconnected.
* Service governance: Define service meta-information formats and service governance specific capabilities, describing the effects these capabilities are intended to achieve.
* Service observability: Define the data format of service observability to lay a foundation for distributed tracing, service governance capability visualization, and etc.

## Architecture of OpenSergo

![architecture](./images/architecture.png)

Introduction to modules:

* Control plane (responsible for receiving reported metadata and delivering service governance rules) : End users can view and modify service governance configurations through either the dashboard or through the kubernates CRD.
* Data plane (responsible for receiving and applying service governance configuration) : generally refers to various microservice frameworks, which can be divided into three main forms: SDK, Java Agent and Sidecar.
* Communication protocol: OpenSergo protocol is used to communicate between the control plane and data plane.

## OpenSergo protocol

The OpenSergo protocol consists of the following parts:

* Service registration and discovery protocol: Define the service registration and discovery communication protocol between services, so that heterogeneous microservices can be interconnected.
* Service metadata protocol: For services, service contract information needs to be reported for service debugging, service routing and other service governance scenarios, as well as heartbeat information to ensure the timeliness of service metadata.
* Service governance rule protocol: defines how service governance rules are delivered and how the data plane listens to service governance configuration information.
* Service Observability protocol (OpenTelemetry) : defines the data format of service observability, laying a foundation for distributed tracing, service governance capability visualization, and etc.

### Communication Protocol

The gRPC protocol is used to report service information, deliver configuration, and listener services.

### Service Governance Spec

- [Service Metadata](./service-metadata.md)
- Service Discovery
- Traffic Orchestration
  - [Traffic Routing](./traffic-routing.md)
  - Traffic Lane
  - [Fault-Tolerance](./fault-tolerance.md)
- [Database Governance](./database-governance.md)
- Cache Governance

## Data-plane and control-plane communication configuration

For the microservice framework connected to OpenSergo, the data-plane needs to communicate with the control plane to report metadata, pull data from the control-plane, and watch service governance configurations. The convention data-plane must access the control-plane using environment variables.

The following two environment variables are used:

1. key is `OPENSERGO_BOOTSTRAP_CONFIG`，
  value is JSON format of service governance access infomation:

  ```json
  {
    "endpoint":"opensergo-pilot.opensergo-pilot.svc.cluster.local:50051"
  }
  ```

2. key is`OPENSERGO_BOOTSTRAP`, value indicates the path of the configuration file. The path points to the service governance configuration file in JSON format.

For the microservice framework, if either of the preceding two environment variables exists, enable the service governance function and establish a connection with the control-plane according to the OpenSergo protocol.

## Appendix

[reference depoyment](../zh-Hans/reference-depoyment.md)

## Credit

* This specification is inspired by envoyproxy/data-plane-api, and [rsocket broker specification](https://github.com/rsocket-broker/rsocket-broker-spec).
* This specification is inspired by protobuf format.
