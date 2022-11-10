<img src="/image/opensergo-logo.svg" alt="OpenSergo Logo" width="50%">

# [OpenSergo 标准规范](./specification/zh-Hans/README.md)

[![License: Apache-2.0](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.txt)

[English](./README.md)

## 概述

OpenSergo 是一套开放通用的、面向云原生服务、覆盖微服务及上下游关联组件的微服务治理标准，并根据标准提供一系列的 API 与 SDK 实现。OpenSergo 项目由阿里巴巴、bilibili、CloudWeGo 等企业与社区联合发起，社区主导共建与演进。

OpenSergo 的最大特点就是**以统一的一套配置/DSL/协议定义服务治理规则，面向多语言异构化架构，做到全链路生态覆盖**。无论微服务的语言是 Java, Go, Node.js 还是其它语言，无论是标准微服务还是 Mesh 接入，从网关到微服务，从数据库到缓存，从服务注册发现到配置，开发者都可以通过同一套 OpenSergo CRD 标准配置针对每一层进行统一的治理管控，而无需关注各框架、语言的差异点，降低异构化、全链路服务治理管控的复杂度。

![landscape](./specification/zh-Hans/images/opensergo-landscape-cn.jpg)

## 项目

* [opensergo-specification](https://github.com/opensergo/opensergo-specification): 定义了 OpenSergo 规范。
* [opensergo-proto](https://github.com/opensergo/opensergo-proto): 定义客户端和控制平面之间通信的 OpenSergo 协议。
* [opensergo-dashboard](https://github.com/opensergo/opensergo-dashboard): 管理异构微服务的统一仪表板。
* [opensergo-control-plane](https://github.com/opensergo/opensergo-control-plane): 负责进行配置转换和分发。
* [opensergo-java-sdk](https://github.com/opensergo/opensergo-java-sdk): 实现 OpenSergo 规范的 Java SDK。
* [opensergo-go-sdk](https://github.com/opensergo/opensergo-go-sdk): 实现 OpenSergo 规范的 Go SDK。

## 社区

### 双周会
* 亚太区友好的社区会议: 亚太区双周会 (开始于 2022 年 4月 27 日), 周三 19:30-20:30(东八区时间)
* 会议时间: [OpenSergo 双周会](https://github.com/opensergo/opensergo-specification/issues/7)

### 联系
[钉钉群](https://www.dingtalk.com/): `34826335`

<img src="image/dingtalk-group.jpg" width="300" />

微信群（添加微信账号并回复 OpenSergo，会你拉进群）：

<img src="image/wechat-group.jpg" width="300" />
