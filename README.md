# Minimal Dockerfiles for Binder customized to enable rJava

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/aculich/minimal-dockerfile-for-rjava/master)

[Binder](https://mybinder.org) needs only one thing for images to work:

- to be able to launch `jupyter notebook` with jupyterlab as a specified user (passed via docker build args as NB_UID/NB_USER)

What this means in practice is that the `notebook` and `jupyterlab` packages must be installed and on PATH:

```docker
RUN pip install --no-cache notebook jupyterlab
```

Note that if you are not installing `jupyterlab` in addition to the classic `notebook`,
you'll need to change your mybinder.org URLs from `/lab` to `/tree` as described
[here](https://mybinder.readthedocs.io/en/latest/howto/user_interface.html#jupyterlab).
Otherwise, you might get a "404: Not Found" error when launching your project on binder.
Now that's *almost* everything.

The remaining piece is that the specified user must be able to *start* the notebook,
which requires certain permissions like being able to write to the home directory.

The absolute bare minimum for this is to set HOME to `/tmp` so that it's writable,
which would make the shortest, smallest Dockerfile that works on Binder:

```docker
FROM python:3.9-slim
RUN pip install --no-cache notebook jupyterlab
ENV HOME=/tmp
```

However, it would be better to consume the NB_UID/NB_USER arguments and create a real user:

```docker
# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
```

From this point, you can start adding files, installing packages, etc.
