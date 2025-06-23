FROM archlinux:latest

RUN useradd -m -G wheel builder
RUN pacman --noconfirm -Syu sudo && echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' | tee /etc/sudoers
RUN pacman --noconfirm -Sy git debugedit fakeroot binutils ntp base-devel ccache

