---
categories: docker
date: "2015-04-12T00:00:00Z"
title: 'Docker Tips #3: How to lose data with a bad CMD'
---

## Scenario

I want to be sure I don't lose data when I stop my container.

### Given
A simple program which add to a list the current time every second (Very critical program) and write the list to a file when it exits.

{{< highlight java >}}
private static final Path parentDirectory = Paths.get("dataFolder");
private static final Path data = Paths.get(parentDirectory.toString(), "data");

public static void main(String[] args) throws IOException, InterruptedException {
    if (!Files.exists(data)) {
        Files.createDirectories(parentDirectory);
        Files.createFile(data);
    }
    List<String> lines = Files.readAllLines(data);

    Runtime.getRuntime().addShutdownHook(new Thread() {
        public void run() {
            Charset charset = Charset.forName("utf-8");
            try (BufferedWriter writer = Files.newBufferedWriter(data, charset)) {
                for (String line : lines) {
                    writer.write(line, 0, line.length());
                    writer.newLine();
                }
            } catch (IOException ex) {
                throw new RuntimeException("Couldn't save lines");
            }
        }
    });

    while (true) {
        lines.add(Instant.now().toString());
        Thread.sleep(1000);
    }
}
{{< / highlight >}}

I assume it's understandable even if you are not familiar with java. If not, let me know and I'll explain it.

### When

I launch it without docker, (```java -jar docker/docker-stop-test-0.1-SNAPSHOT.jar```) wait for a few seconds, then kill it (```kill $(ps aux | grep java | grep docker-stop-test-0.1-SNAPSHOT.jar | awk '{print $2}')```)

### Then
I check in ```dataFolder/data``` file and I see 
{{< highlight bash >}}
$ cat dataFolder/data 
2015-04-12T08:47:16.873Z
2015-04-12T08:47:17.927Z
2015-04-12T08:47:18.928Z
2015-04-12T09:12:16.469Z
2015-04-12T09:12:17.521Z
{{< / highlight >}}


### But

If I kill -9 instead, the data file is empty.

## Let's move to docker now

### Given

A docker image with the jre and my jar installed

{{< highlight docker >}}
ADD docker-stop-test-0.1-SNAPSHOT.jar /

CMD java -jar docker-stop-test-0.1-SNAPSHOT.jar
{{< / highlight >}}

### When

I launch a container, wait for a few seconds, then STOP (not KILL) it

{{< highlight bash >}}
$ docker run --name docker-stop-test-bad-container -v $PWD/dataFolder-bad-cmd:/dataFolder -d docker-stop-test-bad
c08dc515319601d467db02339d3b3a84a03ab99fb4b46811cc5860abf5eea7ec
$ sleep 5
$ docker stop docker-stop-test-bad-container
docker-stop-test-bad-container
{{< / highlight >}}

### Then

I expect to see data in ```dataFolder-bad-cmd/data``` ***right***? ***Wrong***.

There is nothing written in the data file, that means I just lost everything!

## Explanations

If you look at the CMD command: ```CMD java -jar docker-stop-test-0.1-SNAPSHOT.jar``` everything looks ok.
But when you run this image and inspect the created container, you will see this: 

{{< highlight bash >}}
"Cmd": [
            "/bin/sh",
            "-c",
            "java -jar docker-stop-test-0.1-SNAPSHOT.jar"
        ]
{{< / highlight >}}

Docker wrapped my command within a shell script. So what, that's not that big a deal right?

In fact, if you look at the docker [documentation][docker_cmd_doc], you don't see anything useful. You have to look at the [ENTRYPOINT][docker_entrypoint_doc] documentation and dig into it a little to see that: 

> The shell form prevents any CMD or run command line arguments from being used, but has the disadvantage that your ENTRYPOINT will be started as a subcommand of /bin/sh -c, which does not pass signals. This means that the executable will not be the container's PID 1 - and will not receive Unix signals - so your executable will not receive a SIGTERM from docker stop <container>.

## Conclusion

Don't use the most intuitive syntax in the CMD or ENTRYPOINT command, use the exec form. If you replace the CMD command in the dockerfile by this one: 
{{< highlight docker >}}
CMD ["java", "-jar", "docker-stop-test-0.1-SNAPSHOT.jar"]
{{< / highlight >}}

Then everything works like a charm, the SIGTERM is received and the java application save its list into the data file before exiting.


## DIY

If you want to try it by yourself, everything is on my [github repository][sources]. You have two shell scripts: ```docker-build-all.sh``` and ```docker-run-all.sh```. The first will build the images with the bad syntax and the good one. The second script will run containers from these images, wait 5 seconds, stop them.

You can then check in ```dataFolder-bad-cmd/data``` and ```dataFolder-good-cmd/data``` to see the differences.


[docker_cmd_doc]: https://docs.docker.com/reference/builder/#cmd
[docker_entrypoint_doc]: https://docs.docker.com/reference/builder/#entrypoint
[sources]: https://github.com/agileek/docker-tips/tree/master/cmd