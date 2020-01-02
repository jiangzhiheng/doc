一、`Openstack`中的`MQ`

1. 概念

   服务内组件之间的消息全部通过`MQ`来进行转发，包括控制，查询，监控指标等

2. `Rabbit`中的基本概念

   - `Exchange`：消息交换机，它指定消息按照什么规则，路由到哪个队列

   - `Queue`：消息队列载体，每个消息都会被投入到一个或多个队列

   - `Binding`：绑定，它的作用就是把`exchange`和`queue`按照路由规则绑定起来

   - `Routing Key`：路由关键字，`exchange`根据这个关键字进行消息投递

   - `Producer`
   - `Consumer`
   - `Vhost`

二、`Glance`组件

