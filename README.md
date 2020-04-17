# Ilblu

[![GitHub-CI Workflow Status](https://badgen.net/github/checks/Paul1365972/Ilblu?label=Github%20Build&icon=github)](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
[![CodeMC-CI Build Status](https://badgen.net/runkit/jenkins-status-vbryjbp7mcuc/ci.codemc.io%2Fjob%2FPaul1365972%2Fjob%2FIlblu?label=CodeMC%20Build&icon=https%3A%2F%2Fsvgshare.com%2Fi%2FK8A.svg&cache=900)](https://ci.codemc.io/job/Paul1365972/job/Ilblu/lastBuild/)
[![Paper Behind By](https://badgen.net/runkit/behind-paper-0pf96gidt2a1/Paul1365972/Ilblu?icon=git&cache=1800)](https://github.com/PaperMC/Paper)
[![Forks](https://badgen.net/github/forks/Paul1365972/Ilblu?label=Forks&cache=3600)](https://github.com/Paul1365972/Ilblu/network/members)

Ilblu is a fork of the Minecraft Server Software [Paper](https://github.com/PaperMC/Paper), it should support all Spigot plugins.
This project uses combined changes and small improvements from:
- [Paper](https://github.com/PaperMC/Paper)*
- [byof](https://github.com/electronicboy/byof)
- [EMC](https://github.com/starlis/empirecraft)
- [Tuinity](https://github.com/Spottedleaf/Tuinity)
- [Purpur](https://github.com/pl3xgaming/Purpur)
- [YAPFA](https://github.com/tr7zw/YAPFA)
- [Draco](https://github.com/Draycia/Draco)
- [Akarin](https://github.com/Akarin-project/Akarin)

*Projects whose patches were copied are marked with an Asterisk*

The main goal of this project is creating a better framework for forks of paper and in turn also their forks

## TODO

- [x] Actions/Workflow Integration
- [x] Improve README for newer users
- [ ] Switch from Maven to Gradle (1/2)
  - [x] Get rid of ugly build.gradle hack (2/2)
  - [ ] Create gradle task chain (1/2)
  - [x] Only include important imports (2/2)
- [ ] Further improve scripts
  - [x] Make scripts space safe
  - [x] Rewrite all scripts
  - [x] Make more paper like (2/2)
  - [ ] Test mc-dev imports
  - [ ] Test library imports
- [ ] Actually make changes to the game
- [x] Centralise constants (2/2)
  - [x] Resource Token replacement
  - [x] Source code Token replacement
- [ ] Reenable repositories and pushes
- [ ] Make as easily forkable as possible
  - [ ] Multi forking support

## Get Ilblu

### Download

- [**Github Actions**](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
- [**CodeMC Jenkins**](https://ci.codemc.io/job/Paul1365972/job/Ilblu/lastSuccessfulBuild)

### Plugin API

**[WIP]**

**Maven**
```xml
<repository>
    <id>codemc-snapshots</id>
    <url>https://repo.codemc.io/repository/maven-snapshots/</url>
</repository>

<dependency>
    <groupId>io.github.paul1365972</groupId>
    <artifactId>ilblu-api</artifactId>
    <version>1.15.2-R0.1-SNAPSHOT</version>
    <scope>provided</scope>
</dependency>
```

**Gradle**
```groovy
repositories {
    maven {
        url "https://repo.codemc.io/repository/maven-snapshots/"
    }
}

dependencies {
    compileOnly "io.github.paul1365972:ilblu-api:1.15.2-R0.1-SNAPSHOT"
}
```

This also includes the Paper-, Spigot- and Bukkit-API

### Build

#### Requirements

- Java (JDK) 8 or above
- Maven
- Git, with a configured user name and email. 
  On windows you need to run from git bash.

#### Compile

If all you want is a paperclip server jar, just run:
```sh
`./gradlew paperInit paperApply paperclip`
```

## Developing

To get started clone this repository and run `./ilblu patch init` or `./gradlew paperInit paperApplyPatches` to setup your workspace.

### Creating patches

- Make changes to Ilblu-API or Ilblu-Server and commit them
- Run `./ilblu rebuild` or `./gradlew paperRebuildPatches` to create the patch files
- Finish by committing and pushing the changes made to the patch files

### Testing

**Important: Test jars contain copyrighted material and should be distributed under no circumstances**

To build your test server jar just run `./gradlew shadowJar`, output in Ilblu-Server/build/libs

### Deploying

To get a distributable server jar (paperclip), just run `./gradlew paperclip`, output in main directory

### Still confused?

Creating and editing patches is explained in great detail over at [PaperMC](https://github.com/PaperMC/Paper/blob/master/CONTRIBUTING.md).

*Side note: Rebasing will be one of your best friends when creating patches, be sure to understand it well.*

## LICENSE

See [LICENSE](LICENSE)

Everything in this repository is free to be used in your own fork, except when noted otherwise. 

See list above for the license of material used/modified by this project.
