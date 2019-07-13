# CI/CD
![CI/CD流程](http://pcpj2g4mj.bkt.clouddn.com/18-11-9/79775647.jpg)
- CI 持续集成(CONTINUOUS INTEGRATION)

<br>包涵:
1. 自动化构建Continuous Build
2. 自动化测试Continuous Test
3. 自动化集成Continuous Intergration

将不同服务，不同成员的代码集成到项目中，自动化运行测试结果反馈给各个成员，CI服务器Jenkins，用于整合版本控制和构建工作，并管理、控制自动化的持续集成

- CD 持续交付(CONTINUOUS Delivery)

持续交付就是讲我们的应用发布出去的过程。需要有自动化的发布流，以及通过自动化工具随时随地实现应用的部署上线，这个交付目标是QA(Quality Assurance)

- CD 持续部署(CONTINUOUS DEPLOYMENT)
开发人员在主分支中合并一个提交时，这个分支将被构建、测试，如果一切顺利，则部署到生产环境中。这个的交付目标是客户，真正的生产环境。