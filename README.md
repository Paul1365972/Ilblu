# Ilblu

[![GitHub-CI Workflow Status](https://badgen.net/github/checks/Paul1365972/Ilblu?label=Github%20Build&icon=github)](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
[![CodeMC-CI Build Status](https://badgen.net/runkit/jenkins-status-vbryjbp7mcuc/ci.codemc.io%2Fjob%2FPaul1365972%2Fjob%2FIlblu?label=CodeMC%20Build&icon=https%3A%2F%2Fsvgshare.com%2Fi%2FKEK.svg&cache=900)](https://ci.codemc.io/job/Paul1365972/job/Ilblu/)
[![Paper Behind By](https://badgen.net/runkit/behind-paper-0pf96gidt2a1/Paul1365972/Ilblu?icon=git&cache=1800)](https://github.com/PaperMC/Paper)
[![Forks](https://badgen.net/github/forks/Paul1365972/Ilblu?label=Forks&icon=https%3A%2F%2Fsvgshare.com%2Fi%2FKFz.svg&cache=3600)](https://github.com/Paul1365972/Ilblu/network/members)

Ilblu is a fork of the Minecraft Server Software [Paper](https://github.com/PaperMC/Paper), it should support all Spigot plugins.

This project improves on the framework by [byof](https://github.com/electronicboy/byof) and [EMC](https://github.com/starlis/empirecraft). Also includes many small changes from [Tuinity](https://github.com/Spottedleaf/Tuinity), [Purpur](https://github.com/pl3xgaming/Purpur), [YAPFA](https://github.com/tr7zw/YAPFA), [Draco](https://github.com/Draycia/Draco) and [Akarin](https://github.com/Akarin-project/Akarin).

The main goal of this project is creating a better framework for forks of paper and in turn also their forks!

## Example projects

**Small showcase of all current forks of Ilblu:**

- [Ibento](https://github.com/Paul1365972/Ibento) - Adds many new Events

## Get Ilblu

### Download

- [**Github Actions**](https://github.com/Paul1365972/Ilblu/actions?query=workflow%3A%22Build%22)
- [**CodeMC Jenkins**](https://ci.codemc.io/job/Paul1365972/job/Ilblu/lastSuccessfulBuild)

*Downloading Ilblu isnt really useful as it doesnt add any features. This project is meant to be forked!*


### Build

#### Requirements

- Java (JDK) 8 or above
- Maven
- Git, with a configured user name and email. 
  On windows you need to run from git bash.

#### Compile

If all you want is a paperclip server jar, just run:
```sh
./gradlew paperInit paperApply paperclip
```

## Fork

Creating a fork via Ilblu has several advantages:
- Modular inclusion of other forks
- More modern framework for developing than older solutions (E.g byof)
- Incremental building

### Getting started

1. Fork this project
2. Edit `gradle.properties` to your likings
3. Add your fork name to the end of `/patches/apply`
4. Run ```./gradlew paperInit paperApplyPatches paperRebuildPatches```
5. (Edit the README.md)

### Add foreign patches

Create a new folder in `/patches` containing the api and server subdirectories

Now add the relative path to the patches folder above your fork in `/patches/apply`

### Keep in sync

Since Ilblu is patched frequently to stay up to date with [Paper](https://github.com/PaperMC/Paper), keeping your fork in sync is important to get any new features as soon as they come out. Choose any way you prefer:

- Sync Ilblu (Recommended): `./gradlew paperSync`

- Only update Paper: `./gradlew paperMergeUp`

- Do it by manually. Not sure how? [GitHub Help - Syncing a Fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork)

## Developing

To get started clone this repository and run `./gradlew paperInit paperApplyPatches` or `./ilblu patch init` to setup your workspace.

### Creating patches

- Make changes to `/<NAME>-API` or `/<NAME>-Server` and commit them
- Run `./gradlew paperRebuildPatches` or `./ilblu rebuild`  to create the patch files
- Finish by committing and pushing the changes made to the patch files

### Testing

**Important: Test jars contain copyrighted material and should be distributed under no circumstances**

To build your test server jar just run ```./gradlew shadowJar```, output in `/<NAME>-Server/build/libs`

### Deploying

To get a distributable server jar (paperclip), just run ```./gradlew paperclip```, output in main directory

### Still confused?

Just head over to the example project [Ibento](https://github.com/Paul1365972/Ibento).

Creating and editing patches is explained in great detail over at [PaperMC](https://github.com/PaperMC/Paper/blob/master/CONTRIBUTING.md).

*Side note: Rebasing will be one of your best friends when creating patches, be sure to understand it well.*

## LICENSE

See [LICENSE](LICENSE)

Everything in this repository is free to be used in your own fork, except when noted otherwise. 

See list above for the license of material used/modified by this project.
