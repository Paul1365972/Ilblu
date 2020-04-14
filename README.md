# Ilblu

[![GitHub-CI Workflow Status](https://img.shields.io/github/workflow/status/Paul1365972/Ilblu/Build/master?label=Github%20Build&logo=github)](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
[![CodeMC-CI Build Status](https://ci.codemc.io/job/Paul1365972/job/Ilblu/badge/icon?subject=CodeMC%20Build)](https://ci.codemc.io/job/Paul1365972/job/Ilblu/)
[![Paper Behind By](https://badgen.net/runkit/behind-paper-0pf96gidt2a1/Paul1365972/Ilblu?icon=git&cache=600)](https://github.com/PaperMC/Paper)

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
  - [ ] Create gradle task chain
  - [ ] Only include important imports (1/2)
- [ ] Further improve scripts
  - [x] Make scripts space safe
  - [x] Rewrite all scripts
  - [x] Make more paper like (2/2)
  - [ ] Test mc-dev imports
  - [ ] Test library imports
- [ ] Actually make changes to the game
- [ ] Centralise constants (1/2)
  - [x] Resource Token replacement
  - [ ] Source code Token replacement
  - [ ] Reenable repositories and pushes
- [ ] Make as easily forkable as possible
  - [ ] Multi forking support

## Get Ilblu

### Download

- [**Github Actions**](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
- [**CodeMC Jenkins**](https://ci.codemc.io/job/Paul1365972/job/Ilblu/)

### Plugin API

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
./ilblu jar
```
alternatively you can also use `./gradlew paperclip`

## Developing

To get started clone this repository and run `./ilblu patch` or `./gradlew paperApplyPatches` to setup your workspace.

### Creating patches

- Make changes to Ilblu-API or Ilblu-Server and commit them
- Run `./ilblu rebuild` or `./gradlew paperRebuildPatches` to create the patch files
- Finish by committing and pushing your changes to the patch files

### Testing

**Important: Test jars contain copyrighted material and should be distributed under no circumstances**

You have two options for building your test server jar

**Gradle (recommended):** Run `./gradlew shadowJar`, output in Ilblu-Server/build/libs

**Bash:** Run `./ilblu build` (or `./gradlew paperBuild`), output in Ilblu-Server/target

### Deploying

To get a distributable server jar (paperclip) you again have two options

**Gradle (recommended):** Run `./gradlew paperclip`

**Bash:** Run `./ilblu jar` (or `./gradlew paperPaperclip`)

*Important for Bash: Commit any changes and rebuild your patches before deploying or they will be lost forever*

### Still confused?

Creating and editing patches is explained in great detail over at [PaperMC](https://github.com/PaperMC/Paper/blob/master/CONTRIBUTING.md).

*Side note: Rebasing will be one of your best friends when creating patches, be sure to understand it.*

## LICENSE

See [LICENSE](LICENSE.md)

Everything in this repository is free to be used in your own fork, except when noted otherwise. 

See list above for the license of material used/modified by this project.

**By using this project you accept the [Mojang EULA](https://account.mojang.com/documents/minecraft_eula)! Using this project requires that you have read and accepted the EULA because of [this patch](https://github.com/Paul1365972/Ilblu/blob/master/patches/server/0004-Auto-accept-EULA.patch)!**
