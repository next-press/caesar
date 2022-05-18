# Caesar
NextPress' Lean docker-based **WordPress** development environment.

## Introduction

The idea is simple: automate the spinning of new development environments that are fast, debuggable, capable of supporting HTTPs out of the box.

It also register additional commonly used subdomains, as well as three automatically generated domains that can be used for testing mapped domain features.

## Requirements

As of now, this tool only supports macOS (it should support Linux as well, but that was not yet tested).

- File `.npmrc` with your GitHub access token on your home;
- macOS Catalina or up;
- Docker
- Docker Compose

## Installing

*Note: You don't need to install it to use it, you can simply use `npx @next-press/caesar <command>`.*

To install it, run:
```
npm install -g @next-press/caesar
```

That should make the command globally available on your system, so you can run it directly via `caesar <command>`.

## Using it

### Creating a new environment

To create a new environment, run:
```
caesar init <folder-name> <domain-name>
```

This will create a new folder with the `folder-name` and instantiate a new environment using the `domain-name`.

For example, running `caesar init my-site my-site.dev` will create a new folder called `my-site`, install WordPress (multisite subdirectory by default), and setup the local domain `my-site.dev` (and a bunch of others).

#### Defining the installation type

By default, Caesar init installs WordPress as a Multisite subdirectory install. You can change that behavior by passing an environment variable called `INSTALL_TYPE`. It cam take three possible values: `single`, `subdomain`, and `subdir` (default).

To install a single install, for example:
```
INSTALL_TYPE=single caesar init <folder-name> <domain-name>
```

### Spinning a environment up

To spin an existing Caesar environment up, simply run the command below inside the project folder:
```
caesar up
```

### Taking the containers down

To shutdown a particular site, run the command below inside the project folder:
```
caesar down
```

To shutdown all containers, run:
```
caesar shutdown
```

## Additional Tools

### PHP Info

You can check the current PHP info by adding `?info=1` into the end of any site URL.

### XDebug

XDebug is installed and configured out-of-the-box. The project folder gets a copy of `.vscode/launch.json` already configured with the correct path mappings. You can simply turn it on and start debugging.

### Installed Plugins

Caesar installs and activated Query Monitor by default, and installs Debug Bar Slow Actions (without activating it).

## Todo List

- [X] ~~xdebug support~~
- [X] ~~Multisite sub-domain and subdir support~~
- [X] ~~Single site install~~
- [X] ~~Support to multiple sites running at the same time~~
- [ ] Leaner WordPress Image
- [ ] Maybe share the same MariaDB instance (?)
- [ ] Container reset via `caesar reset`, to restore install to a fresh install
- [ ] Auto-clone NextPress repositories and mount the folders into the plugins folder
- [ ] Move plugins to install to external config file