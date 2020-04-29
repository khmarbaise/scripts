Analyzing your local Maven cache
=================

There had been a question in a discussion:

* How many plugins are in my local repository?
* How large are those plugins in total in bytes?

## How many plugins are in my local repository?

After a while thinking you can get the plugins via:
```bash
grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository
```
This will give a list like this (only excerpt):
```
repository/pl/project13/maven/git-commit-id-plugin/2.2.5/git-commit-id-plugin-2.2.5.pom
repository/pl/project13/maven/git-commit-id-plugin/3.0.1/git-commit-id-plugin-3.0.1.pom
repository/pl/project13/maven/git-commit-id-plugin/3.0.0/git-commit-id-plugin-3.0.0.pom
repository/pl/project13/maven/git-commit-id-plugin/2.2.6/git-commit-id-plugin-2.2.6.pom
repository/net/alchim31/maven/scala-maven-plugin/3.1.0/scala-maven-plugin-3.1.0.pom
repository/net/revelc/code/impsort-maven-plugin/1.2.0/impsort-maven-plugin-1.2.0.pom
repository/net/revelc/code/formatter/formatter-maven-plugin/2.8.1/formatter-maven-plugin-2.8.1.pom
repository/net/nicoulaj/maven/plugins/checksum-maven-plugin/1.7/checksum-maven-plugin-1.7.pom
repository/net/nicoulaj/maven/plugins/checksum-maven-plugin/1.8/checksum-maven-plugin-1.8.pom
repository/org/assertj/assertj-assertions-generator-maven-plugin/2.1.0/assertj-assertions-generator-maven-plugin-2.1.0.pom
repository/org/mortbay/jetty/maven-jetty-plugin/6.1.1/maven-jetty-plugin-6.1.1.pom
repository/org/pitest/pitest-maven/1.4.10/pitest-maven-1.4.10.pom
repository/org/pitest/pitest-maven/1.3.1/pitest-maven-1.3.1.pom
repository/org/pitest/pitest-maven/1.4.9/pitest-maven-1.4.9.pom
repository/org/pitest/pitest-maven/1.4.5/pitest-maven-1.4.5.pom
repository/org/pitest/pitest-maven/1.4.3/pitest-maven-1.4.3.pom
repository/org/owasp/dependency-check-maven/4.0.2/dependency-check-maven-4.0.2.pom
repository/org/jooq/jooq-codegen-maven/3.9.6/jooq-codegen-maven-3.9.6.pom
repository/org/jooq/jooq-codegen-maven/3.11.11/jooq-codegen-maven-3.11.11.pom
repository/org/jooq/jooq-codegen-maven/3.9.4/jooq-codegen-maven-3.9.4.pom
repository/org/eclipse/sisu/sisu-maven-plugin/0.3.3/sisu-maven-plugin-0.3.3.pom
repository/org/eclipse/sisu/sisu-maven-plugin/0.3.4/sisu-maven-plugin-0.3.4.pom
repository/org/eclipse/jetty/jetty-maven-plugin/9.4.14.v20181114/jetty-maven-plugin-9.4.14.v20181114.pom
repository/org/eclipse/jetty/jetty-maven-plugin/9.4.11.v20180605/jetty-maven-plugin-9.4.11.v20180605.pom
repository/org/eclipse/jetty/toolchain/jetty-orbit-maven-plugin/1.0/jetty-orbit-maven-plugin-1.0.pom
repository/org/eclipse/tycho/tycho-p2-plugin/0.22.0/tycho-p2-plugin-0.22.0.pom
...
```
So this will every plugin in each version. So you can simply count how many of them existing via:
```bash
grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository | wc -l
```
which will result (in my case):
```bash
     572
```
which means I have 572 plugins in my local cache directory. This includes all different versions as you 
can already see based on the above output for example `git-commit-id-plugin-*`.

So now we want to extract the information about the plugins but we want to remove the version part from the output:
```bash
grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository | sed 's!^\(.*\)/\(.*\)/.*\.pom$!\1!'
```
this would result in something similar like this:
```bash
repository/org/apache/xbean/maven-xbean-plugin
repository/org/apache/xbean/maven-xbean-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/felix/maven-bundle-plugin
repository/org/apache/commons/commons-release-plugin
repository/org/apache/commons/commons-build-plugin
repository/org/apache/commons/commons-build-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-war-plugin
repository/org/apache/maven/plugins/maven-compiler-plugin
```
Based on the above you could simply count how many versions of `maven-bundle-plugin` are existing in 
the local repository or more in general like this:
```bash
grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository | sed 's!^\(.*\)/\(.*\)/.*\.pom$!\1!' | uniq -c
```
this will result in like this:
```bash
   4 repository/pl/project13/maven/git-commit-id-plugin
   1 repository/net/alchim31/maven/scala-maven-plugin
   1 repository/net/revelc/code/impsort-maven-plugin
   1 repository/net/revelc/code/formatter/formatter-maven-plugin
   2 repository/net/nicoulaj/maven/plugins/checksum-maven-plugin
   1 repository/org/assertj/assertj-assertions-generator-maven-plugin
   1 repository/org/mortbay/jetty/maven-jetty-plugin
   5 repository/org/pitest/pitest-maven
   1 repository/org/owasp/dependency-check-maven
   3 repository/org/jooq/jooq-codegen-maven
   2 repository/org/eclipse/sisu/sisu-maven-plugin
   2 repository/org/eclipse/jetty/jetty-maven-plugin
   1 repository/org/eclipse/jetty/toolchain/jetty-orbit-maven-plugin
   1 repository/org/eclipse/tycho/tycho-p2-plugin
   3 repository/org/eclipse/tycho/tycho-maven-plugin
   1 repository/org/eclipse/tycho/target-platform-configuration
   1 repository/org/eclipse/tycho/tycho-packaging-plugin
   1 repository/org/eclipse/tycho/tycho-compiler-plugin
   3 repository/org/asciidoctor/asciidoctor-maven-plugin
   3 repository/org/jvnet/maven-jellydoc-plugin/maven-jellydoc-plugin
   1 repository/org/jvnet/jaxb2/maven2/maven-jaxb22-plugin
   2 repository/org/jvnet/jaxb2/maven2/maven-jaxb2-plugin
   1 repository/org/jvnet/jaxb2/maven2/maven-jaxb23-plugin
   1 repository/org/antlr/antlr3-maven-plugin
   1 repository/org/moditect/moditect-maven-plugin
   1 repository/org/sonarsource/sonar-packaging-maven-plugin/sonar-packaging-maven-plugin
   1 repository/org/sonarsource/scanner/maven/sonar-maven-plugin
   1 repository/org/tomitribe/crest-maven-plugin
   1 repository/org/fusesource/hawtbuf/hawtbuf-protoc
   1 repository/org/jetbrains/kotlin/kotlin-maven-plugin
   7 repository/org/jacoco/jacoco-maven-plugin
   1 repository/org/eluder/coveralls/coveralls-maven-plugin
  22 repository/org/springframework/boot/spring-boot-maven-plugin
```
So you can see in each line a single plugin is represented which prefixed by it's count. 
This means that the `pitest-maven` plugin does exist in five versions in my local cache.
This gives you an impression of the distribution of the different plugins in your local cache.

So now the total number of plugins in a local cache which can be done via:
```bash
grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository | sed 's!^\(.*\)/\(.*\)/.*\.pom$!\1!' | uniq -c | tr -s " " | cut -d " " -f2 | paste -sd+ -| bc
```
which will result in:
```bash
572
```
That means I have in total 572 plugins installed in my local cache directory. (The total number 
has already been calculated at the beginning.)


## How large are those plugins in total in bytes?

The size for all files of a plugin is a little bit tricker but can be solved via the following small shell script:
```bash
#!/bin/bash
POMFILES=`grep -l -r  "<packaging>maven-plugin</packaging>" --include '*.pom' repository`

for i in $POMFILES; do
	BASEFILE=${i::${#i}-4}	
	BYTES_PER=`ls -la $BASEFILE.* | tr -s " " | cut -d " " -f5 | paste -sd+ - | bc`
	echo $BYTES_PER
done;
```
The line `BASEFILE=${i::${#i}-4}` will remove the `.pom` from the filename and the line
`ls -la $BASEFILE.* | tr -s " " | cut -d " " -f5 | paste -sd+ - | bc` will list all files with
the filename pattern and in the end it will add the file sizes of each file. Via the output
of the shell script we can now summarize the total sum in bytes via:
```bash
./find_maven_plugins.sh | paste -sd+ - | bc 
```
which will printout for local cache:
```bash
52268062
```
which means 52.268.062 bytes (ca. 49 MiB).

