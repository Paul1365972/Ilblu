# Ilblu

Fork of [Paper](https://github.com/PaperMC/Paper)* using combined changes and small improvements from:
- [byof](https://github.com/electronicboy/byof/)
- [EMC](https://github.com/starlis/empirecraft)
- [Tuinity](https://github.com/Spottedleaf/Tuinity)
- [Purpur](https://github.com/pl3xgaming/Purpur)
- [YAPFA](https://github.com/tr7zw/YAPFA)
- [Draco](https://github.com/Draycia/Draco)

*Projects whose patches were copied are marked with an Asterisk*

All game breaking changes will be disabled by default

## TODO

- [ ] Actions/Workflow Integration
- [ ] Improve README for newer users
- [ ] Switch from Maven to Gradle (1/2)
  - [x] Get rid of ugly build.gradle hack (2/2)
  - [ ] Create gradle task chain
  - [ ] Only include important imports (1/2)
- [ ] Further improve scripts
  - [x] Make scripts space safe
  - [x] Rewrite all scripts
  - [ ] Make more paper like (1/2)
  - [ ] Test mc-dev imports
  - [ ] Test library imports
- [ ] Actually make changes to the game
- [ ] Centralise constants
  - [x] Resource Token replacement
  - [ ] Source code Token replacement
  - [ ] Reenable repositories and pushes
- [ ] Make as easily forkable as possible
  - [ ] Multi forking support

## Building

Requirements:
- You need `git` installed, with a configured user name and email. 
   On windows you need to run from git bash.
- You need `maven` installed
- You need `jdk` 8+ installed to compile (and `jre` 8 to run)
- Anything else that `paper` requires to build
- Not yet needed, but `gradle` will be used in the future

If all you want is a paperclip server jar, just run `./ilblu jar`

Otherwise, to setup the `Ilblu-API` and `Ilblu-Server` repo, just run the following command
in your project root `./ilblu patch` additionally, after you run `./ilblu patch` you can run `./ilblu build` to build the 
respective api and server jars.

`./ilblu patch` should initialize the repo such that you can now start modifying and creating
patches. The folder `Ilblu-API` is the api repo and the `Ilblu-Server` folder
is the server repo and will contain the source files you will modify.

Creating new patches is explained in great detail over at [PaperMC](https://github.com/PaperMC/Paper/blob/master/CONTRIBUTING.md)

## LICENSE

Everything is licensed under the MIT license, and is free to be used in your own fork, except when noted otherwise. 

See list above for the license of material used/modified by this project.

**By using this project you accept the [Mojang EULA](https://account.mojang.com/documents/minecraft_eula)! Using this project requires that you have read and accepted the EULA because of [this patch](https://github.com/Paul1365972/Ilblu/blob/master/patches/server/0004-Auto-accept-EULA.patch)!**
