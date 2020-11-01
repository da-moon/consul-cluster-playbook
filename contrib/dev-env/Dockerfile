FROM alpine
# building vim
ENV MAKEFLAGS="-j$(nproc)"
ENV CFLAGS=""
ENV USER "developer"

USER root
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --no-cache add \
    ncurses \
	cmake \
	py3-pip \
	bash \
	sudo \
	curl \
	build-base \
	ctags \
	git \
	libx11-dev \
	libxpm-dev \
	libxt-dev \
	make \
	ncurses-dev \
	ncurses-static \
	apk-tools-static \
	python3-dev \
	gcc \
	musl-dev \
	libffi-dev \
	openssl-dev 
RUN getent group sudo > /dev/null || sudo addgroup sudo
RUN getent group ${USER} > /dev/null || sudo addgroup ${USER}
RUN getent passwd ${USER} > /dev/null || sudo adduser \
    -G sudo \
    -h "/home/${USER}" \
    -s /bin/bash \
    -u 33333 \
    -D \
    "${USER}" "${USER}"
COPY vimrc /home/${USER}/.vimrc
COPY vimrc.d /home/${USER}/.vimrc.d
RUN echo "${USER}:${USER}" | chpasswd && \
    sed -i.bak -e "s/# %sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g" /etc/sudoers && \
    mkdir -p /workspace && \
    chown "$USER:$USER" /workspace -R && \
    chown "$USER:$USER" /home/${USER}/ -R
# building vim from source
RUN git clone https://github.com/vim/vim /tmp/vim 
WORKDIR /tmp/vim
RUN ./configure \
      --prefix=/usr/local \
      --with-compiledby=da-moon \
      --with-modified-by=da-moon \
      --enable-fail-if-missing \
      --enable-fontset \
      --enable-cscope \
      --enable-terminal \
      --enable-multibyte \
      --enable-largefile \
      --enable-python3interp=yes \
      --with-python3-config-dir=$(python3-config --configdir) \
      --with-tlib=ncursesw \
      --with-x \
      --with-features=huge 
RUN make install && \
    vim --version && \
    ldd $(which vim)
USER ${USER}
RUN sudo echo "Running 'sudo' for ${USER} : success" && \
    echo 'export PATH=$PATH:~/.local/bin/'
# installing ansible generator
RUN python3 -m pip install -U ansible-generator
RUN (echo | vim +PlugInstall +qall > /dev/null && echo 0) || true
RUN (echo | vim -c "CocInstall -sync coc-tsserver \
            coc-git \
            coc-bookmark \
            coc-snippets \
            coc-highlight \
            coc-json \
            coc-lists \
            coc-markdownlint \
            coc-tabnine \
            coc-tasks \
            coc-todolist \
            coc-template \
            coc-yank \
            coc-pairs \
            coc-svg \
            coc-spell-checker \
            coc-yaml \
            coc-sh \
            coc-prettier|q" > /dev/null && \
            echo 0 ) || true
# => cleanups
RUN rm -rf ~/.cache/* && \
    sudo rm -rf /tmp/*
ENTRYPOINT bash -c "sudo chown '$USER:$USER' /workspace -R && bash"
