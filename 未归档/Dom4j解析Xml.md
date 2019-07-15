# Java DOM4J解析器
## 介绍
DOM4J是一个开源的，基于Java的库来解析XML文档，它具有高度的灵活性，高性能和内存效率的API。这是java的优化，使用Java集合像列表和数组。它可以使用DOM，SAX，XPath和XSLT。它解析大型XML文档时具有极低的内存占用。

## 优点
DOM4J使Java开发的灵活性和XML解析代码易于维护。它是轻量级的，快速的API。

DOM4J 类
DOM4J定义了几个Java类。以下是最常见的类：

Document - 表示整个XML文档。文档Document对象是通常被称为DOM树。
Element - 表示一个XML元素。 Element对象有方法来操作其子元素，它的文本，属性和名称空间。
Attribute - 表示元素的属性。属性有方法来获取和设置属性的值。它有父节点和属性类型。
Node - 代表元素，属性或处理指令
常见DOM4J的方法
当使用DOM4J，还有经常用到的几种方法：

SAXReader.read(xmlSource)() - 构建XML源的DOM4J文档。
Document.getRootElement() - 得到的XML的根元素。
Element.node(index) - 获得在元素特定索引XML节点。
Element.attributes() - 获取一个元素的所有属性。
Node.valueOf(@Name) - 得到元件的给定名称的属性的值。
创建与解析XML示例
官网地址：https://dom4j.github.io/ 
注意：使用Dom4j开发，需下载dom4j相应的jar文件

Maven仓库

```

<dependency>
    <groupId>dom4j</groupId>
    <artifactId>dom4j</artifactId>
    <version>1.6.1</version>
</dependency>

```
```

package com.example;

import java.io.File;  
import java.io.FileOutputStream;  
import java.io.OutputStreamWriter;  
import java.util.Iterator;  
import java.util.List;  
import org.dom4j.Attribute;  
import org.dom4j.Document;  
import org.dom4j.DocumentHelper;
import org.dom4j.Element;  
import org.dom4j.io.OutputFormat;  
import org.dom4j.io.SAXReader;  
import org.dom4j.io.XMLWriter;  
import org.junit.Test;  

public class Demo01 {  

    @Test  
    public void readXMLDemo() throws Exception {  

        // 创建saxReader对象  
        SAXReader reader = new SAXReader();  
        // 通过read方法读取一个文件 转换成Document对象  
        Document document = reader.read(new File("src/car.xml"));  
        //获取根节点元素对象  
        Element node = document.getRootElement();  
        //遍历所有的元素节点  
        // listNodes(node); 

        elementMethod(node);

    } 

    @Test
    public void createXMLDemo() throws Exception {  
         Document document = DocumentHelper.createDocument();
         Element root = document.addElement( "cars" );
         Element supercarElement= root.addElement("supercars")
            .addAttribute("company", "Ferrai");

         supercarElement.addElement("carname")
            .addAttribute("type", "Ferrari 101")
            .addText("Ferrari 101");

         supercarElement.addElement("carname")
            .addAttribute("type", "sports")
            .addText("Ferrari 202");
         // 写入到一个新的文件中 
         writer(document);
    }

    /** 
     * 把document对象写入新的文件 
     *  
     * @param document 
     * @throws Exception 
     */  
    public void writer(Document document) throws Exception {  
        // 紧凑的格式  
        // OutputFormat format = OutputFormat.createCompactFormat();  
        // 排版缩进的格式  
        OutputFormat format = OutputFormat.createPrettyPrint();  
        // 设置编码  
        format.setEncoding("UTF-8");  
        // 创建XMLWriter对象,指定了写出文件及编码格式  
        // XMLWriter writer = new XMLWriter(new FileWriter(new  
        // File("src//a.xml")),format);  
        XMLWriter writer = new XMLWriter(new OutputStreamWriter(  
                new FileOutputStream(new File("src//car.xml")), "UTF-8"), format);  
        // 写入  
        writer.write(document);  
        // 立即写入  
        writer.flush();  
        // 关闭操作  
        writer.close();  
    }  

    /** 
     * 遍历当前节点元素下面的所有(元素的)子节点 
     *  
     * @param node 
     */  
    public void listNodes(Element node) {  
        System.out.println("当前节点的名称：：" + node.getName());  
        // 获取当前节点的所有属性节点  
        List<Attribute> list = node.attributes();  
        // 遍历属性节点  
        for (Attribute attr : list) {  
            System.out.println(attr.getText() + "-----" + attr.getName()  
                    + "---" + attr.getValue());  
        }  

        if (!(node.getTextTrim().equals(""))) {  
            System.out.println("文本内容：：：：" + node.getText());  
        }  

        // 当前节点下面子节点迭代器  
        Iterator<Element> it = node.elementIterator();  
        // 遍历  
        while (it.hasNext()) {  
            // 获取某个子节点对象  
            Element e = it.next();  
            // 对子节点进行遍历  
            listNodes(e);  
        }  
    }  

    /** 
     * 介绍Element中的element方法和elements方法的使用 
     *  
     * @param node 
     */  
    public void elementMethod(Element node) {  
        // 获取node节点中，子节点的元素名称为supercars的元素节点。  
        Element e = node.element("supercars");  
        // 获取supercars元素节点中，子节点为carname的元素节点(可以看到只能获取第一个carname元素节点)  
        Element carname = e.element("carname");  

        System.out.println(e.getName() + "----" + carname.getText());  

        // 获取supercars这个元素节点 中，所有子节点名称为carname元素的节点 。  

        List<Element> carnames = e.elements("carname");  
        for (Element cname : carnames) {  
            System.out.println(cname.getText());  
        }  

        // 获取supercars这个元素节点 所有元素的子节点。  
        List<Element> elements = e.elements();  

        for (Element el : elements) {  
            System.out.println(el.getText());  
        }  
    }  
}  

```