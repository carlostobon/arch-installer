FROM archlinux:latest
RUN pacman -Syu --noconfirm
WORKDIR /app
COPY . .
RUN pacman -S --noconfirm $(cat pacman.arch)
