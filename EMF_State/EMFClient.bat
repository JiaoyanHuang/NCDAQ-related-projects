@echo off

::  Batch file to start the EMF Client


set EMF_HOME=C:\EMF_State
::set EMF_HOME="C:\EMF_State"

set R_HOME=C:\Program Files\R\rw2000\bin

::Check the location of Java on your computer.  Choose one of the following or it may be in Program File (x86)
::set JAVA_EXE=C:\Program Files\Java\jre6\bin\java
::set JAVA_EXE=C:\Program Files (x86)\Java\jre7\bin\java
::set JAVA_EXE=C:\Program Files (x86)\Java\jre1.8.0_77\bin\java
set JAVA_EXE=C:\Program Files (x86)\Java\jre1.8.0_211\bin\java
IF NOT EXIST "%JAVA_EXE%.exe" (
ECHO Java seems to have gone missing, probably upgraded to a new version.  Better find it and fix the batch file.
pause
exit 1
)

::set JAVA_EXE=C:\Program Files (x86)\Java\jre6\bin\java

::  add bin directory to search path

set PATH=%PATH%;%R_HOME%

set TOMCAT_SERVER=http://ec2-54-200-19-3.us-west-2.compute.amazonaws.com:8080
::set TOMCAT_SERVER=http://ec2-54-200-13-202.us-west-2.compute.amazonaws.com:8080 **stopped**
::set TOMCAT_SERVER=http://ec2-54-213-13-183.us-west-2.compute.amazonaws.com:8080
::set TOMCAT_SERVER=http://localhost:8080  **trying AWS IP address above**

:: set needed jar files in CLASSPATH


set CLASSPATH=%EMF_HOME%\lib\activation.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\analysis-engine.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\antlr-2.7.5H3.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\asm-attrs.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\asm.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\axis-ant.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\axis.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\c3p0-0.9.1.2.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\cglib-2.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\cleanimports.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\colt.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\commons-collections-3.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\commons-discovery-0.2.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\commons-logging-1.0.4.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\commons-primitives-1.0.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\concurrent.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\connector.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\cosu.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\dom4j-1.6.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\ehcache-1.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\epa-commons.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\fluent-hc-4.2.5.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\guava-10.0.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\hibernate3.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\httpasyncclient-4.0-beta3.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\httpclient-4.2.5.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\httpcore-4.2.4.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\httpcore-nio-4.2.2.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\iText-5.0.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\javassist-3.9.0.GA.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\java_cup.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\jaxrpc.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\jh.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\jlfgr-1_0.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\jnlp.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\jta.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\kmlGenerator.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\log4j-1.2.9.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\mail.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\mchange-commons-0.2.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\oscache-2.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\proxool-0.8.3.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\saaj-api.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\saaj-impl.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\saaj.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\slf4j-api-1.6.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\slf4j-nop-1.6.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\soap.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\swarmcache-1.0rc2.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\versioncheck.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\weka.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\wsdl4j-1.5.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\xercesSamples.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\xml-apis.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\xmlParserAPIs.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\lib\xstream-1.2.1.jar
set CLASSPATH=%CLASSPATH%;%EMF_HOME%\emf-client.jar


@echo on


"%JAVA_EXE%" -Xmx400M -DUSER_PREFERENCES=%EMF_HOME%\EMFPrefs.txt -DEMF_HOME=%EMF_HOME% -DR_HOME="%R_HOME%" -classpath %CLASSPATH% gov.epa.emissions.framework.client.EMFClient %TOMCAT_SERVER%/emf/services
