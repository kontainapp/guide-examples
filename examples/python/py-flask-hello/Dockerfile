ARG PYTHON_BUILD_IMAGE_VERSION=python:3.9-slim
ARG PYTHON_KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python-3.9:latest

FROM ${PYTHON_BUILD_IMAGE_VERSION} AS build
WORKDIR /opt/src/app

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

ADD . /opt/src/
RUN pip install -r /opt/src/requirements.txt

FROM ${PYTHON_KONTAIN_RELEASE_IMAGE_VERSION} as release
COPY --from=build /opt/venv /opt/venv
ADD app/main.py /opt/src/app/
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/src/app

EXPOSE 5000
CMD ["python", "main.py"]
# CMD . /opt/venv/bin/activate && exec python main.py
