FROM rockylinux:9

RUN \
  dnf -y update && \
  dnf install -y epel-release && \
  dnf -y groups install "Xfce" && \
  dnf -y reinstall \
    shadow-utils && \
  dnf -y install \
    xrdp \
    xorgxrdp \
    vim \
    git \
    ansible-core \
    ansible \
    ansible-collection-ansible-posix.noarch \
    ansible-collection-community-general.noarch \
    python3-pip \
    podman \
    firefox \
    && \
  curl -L -o /tmp/vscode.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64' && \
  dnf -y localinstall /tmp/vscode.rpm  && \
  rm -f /tmp/vscode.rpm && \
  pip install \
    ansible-navigator \
    ansible-lint && \
  dnf clean all && \
  rm -rf /var/cache /var/log/dnf* /var/log/yum.* && \
  sed -i \
      -e 's#^UID_MAX.*$#UID_MAX 9999#g' \
      -e 's#^SUB_UID_MIN.*$#SUB_UID_MIN 10000#g' \
      -e 's#^SUB_UID_MAX.*$#SUB_UID_MAX 65536#g' \
      -e 's#^SUB_UID_COUNT.*$#SUB_UID_COUNT 5000#g' \
      -e 's#^GID_MAX.*$#GID_MAX 9999#g' \
      -e 's#^SUB_GID_MIN.*$#SUB_GID_MIN 10000#g' \
      -e 's#^SUB_GID_MAX.*$#SUB_GID_MAX 65536#g' \
      -e 's#^SUB_GID_COUNT.*$#SUB_GID_COUNT 5000#g' \
      /etc/login.defs

COPY ./build/xrdp.ini /etc/xrdp/

COPY ./build/startwm-xfce.sh /etc/xrdp/
RUN mv /etc/xrdp/startwm-xfce.sh /etc/xrdp/startwm.sh
RUN cp /etc/xrdp/startwm.sh /usr/libexec/xrdp/startwm-bash.sh

COPY ./build/run.sh /
RUN chmod +x /run.sh

EXPOSE 3389

ENTRYPOINT ["/run.sh"]

