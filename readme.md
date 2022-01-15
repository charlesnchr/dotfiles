# Installation
Git clone repository to `~/dotfiles`.

Depending on platform run install scripts.

## MacOS

`install_mac.sh` and then `install.sh`.

## Linux

`install_linux.sh` and then `install.sh`

## Windows

`install_windows.ps1`


## Docker

```
docker build -t nvim-docker .
docker run --privileged --rm -it nvim-docker
```

