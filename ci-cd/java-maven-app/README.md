# Project description
Create a CI/CD pipeline for a Java Maven Application to perform the following actions:

* Dynamically set the application version
* Build artifact for Java Maven application - JAR file
* Build and push Docker image to DockerHub
* Deploy new application version to the EKS cluster
* Commit new application version back to the repository

# Technologies used
Kubernetes, Jenkins, AWS EKS, Docker Hub, Java, Maven, Linux, Docker, Git, Digital Ocean

# Prerequisite
* Java maven application code available at https://github.com/jobyjfrancis/java-maven-app

# Steps performed

## Containerise the Java Maven application

1. Created a new branch named `develop` under the Java Maven application repository and configured `Dockerfile` with the appropriate instructions to containerise it - https://github.com/jobyjfrancis/java-maven-app/blob/develop/Dockerfile

2. Tested the application build and docker image creation

```
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$ mvn clean package
[INFO] Scanning for projects...
[INFO]
[INFO] ---------------------< com.example:java-maven-app >---------------------
[INFO] Building java-maven-app 1.0.0
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ java-maven-app ---
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ java-maven-app ---
[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.6.0:compile (default-compile) @ java-maven-app ---
[INFO] Changes detected - recompiling the module!
[WARNING] File encoding has not been set, using platform encoding UTF-8, i.e. build is platform dependent!
[INFO] Compiling 1 source file to /home/joby/learn/java-maven-app/target/classes
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ java-maven-app ---
[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] skip non existing resourceDirectory /home/joby/learn/java-maven-app/src/test/resources
[INFO]
[INFO] --- maven-compiler-plugin:3.6.0:testCompile (default-testCompile) @ java-maven-app ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ java-maven-app ---
[INFO] No tests to run.
[INFO]
[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ java-maven-app ---
[INFO] Building jar: /home/joby/learn/java-maven-app/target/java-maven-app-1.0.0.jar
[INFO]
[INFO] --- spring-boot-maven-plugin:2.3.5.RELEASE:repackage (default) @ java-maven-app ---
[INFO] Replacing main artifact with repackaged archive
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.211 s
[INFO] Finished at: 2025-11-24T18:41:53+13:00
[INFO] ------------------------------------------------------------------------
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$
```
```
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$ ls -al target/*.jar
-rw-r--r-- 1 joby joby 17200345 Nov 24 18:41 target/java-maven-app-1.0.0.jar
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$
```
```
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$ docker build -t jma:1.0.0 .
[+] Building 3.5s (9/9) FINISHED                                                                                                 docker:default
 => [internal] load build definition from Dockerfile                                                                                       0.0s
 => => transferring dockerfile: 187B                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/amazoncorretto:8-alpine3.17-jre                                                         2.8s
 => [auth] library/amazoncorretto:pull token for registry-1.docker.io                                                                      0.0s
 => [internal] load .dockerignore                                                                                                          0.0s
 => => transferring context: 2B                                                                                                            0.0s
 => [internal] load build context                                                                                                          0.0s
 => => transferring context: 81B                                                                                                           0.0s
 => [1/3] FROM docker.io/library/amazoncorretto:8-alpine3.17-jre@sha256:3dbdce03fbe921966033eca64c4f75c949bbe85785ed243e99ed4a335d784bda   0.0s
 => => resolve docker.io/library/amazoncorretto:8-alpine3.17-jre@sha256:3dbdce03fbe921966033eca64c4f75c949bbe85785ed243e99ed4a335d784bda   0.0s
 => CACHED [2/3] COPY ./target/java-maven-app-*.jar /usr/app/                                                                              0.0s
 => CACHED [3/3] WORKDIR /usr/app                                                                                                          0.0s
 => exporting to image                                                                                                                     0.4s
 => => exporting layers                                                                                                                    0.0s
 => => exporting manifest sha256:41d13f94679977c9efe38c867941021d7f0941ac442184f643bcc630c8414796                                          0.0s
 => => exporting config sha256:4d96f2ae3406764290970ef6b142fa5924c30032e620b4cec04f7b41eae1251e                                            0.0s
 => => exporting attestation manifest sha256:10c1071ff2a5474262a6fd2cc147934caa3f9ac1b5baa7cc513c14af7e174f98                              0.0s
 => => exporting manifest list sha256:21dc03bd1ff08f77363056e3276cbfedfa785ceb2af0ff98f4aad8fdfd8f067f                                     0.0s
 => => naming to docker.io/library/jma:1.0.0                                                                                               0.0s
 => => unpacking to docker.io/library/jma:1.0.0                                                                                            0.2s

 1 warning found (use docker --debug to expand):
 - JSONArgsRecommended: JSON arguments recommended for CMD to prevent unintended behavior related to OS signals (line 8)
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$
```
```
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$ docker images | grep jma
jma                                                                      1.0.0           21dc03bd1ff0   13 hours ago    194MB
joby@LAPTOP-KVPR8SO6:~/learn/java-maven-app (develop)$
```



