FROM ghcr.io/manics/jupyter-desktop-mate:latest@sha256:fc3ac77e66d80f7606be20d9a96a7f926e60b6f5281271bad4ae22b13728628e

USER root

ARG SYSTEMCTL_REPLACEMENT_VERSION=v1.7.1097
ARG NTERACT_VERSION=v2.0.4-stable.202603271826

RUN mv /usr/bin/systemctl /usr/bin/systemctl.orig && \
    curl -sfLo /usr/bin/systemctl "https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/refs/tags/${SYSTEMCTL_REPLACEMENT_VERSION}/files/docker/systemctl3.py" && \
    curl -sfLo /tmp/nteract.AppImage "https://github.com/nteract/desktop/releases/download/${NTERACT_VERSION}/nteract-stable-linux-x64.AppImage" && \
    chmod +x /usr/bin/systemctl /tmp/nteract.AppImage && \
    /tmp/nteract.AppImage --appimage-extract && \
    rm /tmp/nteract.AppImage && \
    mv squashfs-root /opt/nteract && \
    ln -s /opt/nteract/usr/bin/* /usr/local/bin/

COPY --chown=$NB_UID:$NB_GID nteract.desktop "$HOME_TEMPLATE_DIR/Desktop"

USER $NB_USER
RUN runtimed install && \
    mkdir -p "$HOME_TEMPLATE_DIR/.config/systemd" && \
    rsync -av "$HOME/.config/systemd/" "$HOME_TEMPLATE_DIR/.config/systemd/"
