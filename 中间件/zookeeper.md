# 官网翻译

## Welcome to Apache ZooKeeper™

Apache ZooKeeper致力于开发和维护一个支持高可靠的**分布式协调**的开源服务器。

## What is ZooZeeper？

ZooKeeper是一种集中式服务，用于维护配置信息，命名，提供分布式同步和提供组服务。 所有这些类型的服务都以分布式应用程序的某种形式使用。 每次实施它们都需要做很多工作来修复不可避免的错误和竞争条件。 由于难以实现这些类型的服务，应用程序最初通常会吝啬它们，这使得它们在变化的情况下变得脆弱并且难以管理。 即使正确完成，这些服务的不同实现也会在部署应用程序时导致管理复杂性。

还有集群管理，**分布式锁**(还有基于数据库实现分布式锁 基于缓存（redis，memcached，tair）实现分布式锁)，分布式队列，zookeeper集群leader选举等。

# CAP定理

在一个分布式系统中，**Consistency**（一致性）、 **Availability**（可用性）、**Partition tolerance**（分区容错性），三者不可得兼。分区容错性一般都要满足，所有在可用性和一致性之间权衡。

![](C:\Users\XIONG\Pictures\IT\CAP定理.jpg)

## Consistency（一致性）



## Availability （可用性）



## Partition Tolerance（分区容错性）



