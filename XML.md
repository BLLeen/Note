
与xml的解析操作一样，在使用DOM创建和写入xml文件的时候，也需要获取一个DocumentBuilderFactory类型的对象builderFactory，并通过builderFactory的newDocumentBuilder()方法获取DocumentBuilder类的一个对象，其中Documentbuilder类定义了由xml文件得到可操作的Document类型的实例的API，也就是说，通过下面这两行代码：

DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
DocumentBuilder builder = builderFactory.newDocumentBuilder();
我们可以得到一个DocumentBuilder类的对象builder，这个类对象的方法属性可供我们操作（读取或者写入）xml文件。
我们通过调用builder的newDocument()方法，可以得到一个Document类型的实例newXML：

Document newXML = builder.newDocument();
得到Document对象后，我们就可以添加内容了。在上一篇文章中，获取xml文件的标签元素时，有外到内的方式，调用getElementsByTagName(String name)方法依次获取根元素，各级子元素。现在我们按照同样的思路，调用createElement(String name)方法，依次添加根元素和各级子元素。首先添加的是根元素“Languages":

org.w3c.dom.Element languages = newXML.createElement("Languages");
标签“Languages“有一个属性'cat"，值为”it"，实现的代码为：

languages.setAttribute("cat", "it");
至此，根元素的内容就设置完成，然后添加子元素。其实现方式一致：
org.w3c.dom.Element lan1 = newXML.createElement("lan");
lan1.setAttribute("id", "1");
org.w3c.dom.Element name1 = newXML.createElement("name");
name1.setTextContent("Java");
org.w3c.dom.Element ide1 = newXML.createElement("ide");
ide1.setTextContent("Eclipse");
子元素”lan"有一个属性“id”，值为1，其包含两个子元素：“name"金额”ide"，调用Element对象的setTextContent(String content)方法可以为子元素添加内容。以上的代码只是创建“lan“及其子元素，要两个子元素与”lan“产生包含联系，还需要一步：
lan1.appendChild(name1);
lan1.appendChild(ide1);
上面两行代码是将元素”name“和"ide"作为”lan”的子元素添加到其内部。这样一个完整的"lan"标签元素就创建完了，由于“lan"是根元素“Languages"的子元素，因此还需要将其添加到根元素的内部：
languages.appendChild(lan1);
同样，由于根元素是属于xml文件（程序中就是Document类的实例newXML）的，因此，还需要将根元素添加到newXML中：
newXML.appendChild(languages);