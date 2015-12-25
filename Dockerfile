FROM gentoo/stage3-amd64-nomultilib:latest

MAINTAINER Arsen A. Gutsal <gutsal.arsen@softsky.com.ua>

RUN emerge --sync \
    && emerge -vuDN world \
    && etc-update --automode -3 \
    && emerge -vuDN world

RUN emerge --depclean

COPY copyables/etc/portage /etc/portage
RUN USE=xvfb emerge --autounmask-write x11vnc google-chrome xorg-server
RUN emerge supervisor
RUN touch ~/.bashrc \
    && wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash \
    && . ~/.bashrc \
    && nvm install node 5.3 \
    && nvm alias default 5.3

COPY copyables/etc/supervisor /etc/supervisor
EXPOSE 5900

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
