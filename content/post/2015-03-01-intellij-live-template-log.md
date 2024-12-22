---
categories: intellij java
date: "2015-03-01T00:00:00Z"
title: Generate log line with Intellij and live templates
---

With IntelliJ, one missing feature is the automatic generation of the famous ```private static Logger LOGGER = ...; ```


You can do it easily with the Live Templates, you just have to go to ***Editor -> Live Templates -> others -> create new***

And in these fields :

* Abbreviation: log
* Description: Add log line
* Template text: 
{{< highlight java >}}
private static final org.slf4j.Logger LOGGER = org.slf4j.LoggerFactory.getLogger($CLASS_NAME$.class);
{{< / highlight >}}

* Applicable in: Java: declaration

* Edit variables: CLASS_NAME Expresion: className()


Make sure you have slf4j-api in your classpath, with maven: 

{{< highlight xml >}}
<dependency>
 <groupId>org.slf4j</groupId>
 <artifactId>slf4j-api</artifactId>
 <version>1.7.7</version>
</dependency>
{{< / highlight >}}

That's it, type `log` and Ctrl+J and it will generate the logger line, with the slf4j imports.