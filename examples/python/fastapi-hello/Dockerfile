ARG PYTHON_BUILD_IMAGE_VERSION=python:3.9-slim
ARG PYTHON_KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python-3.9:latest

FROM ${PYTHON_BUILD_IMAGE_VERSION} AS build
WORKDIR /app

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

ADD . /app
RUN pip install -r /app/requirements.txt

FROM ${PYTHON_KONTAIN_RELEASE_IMAGE_VERSION} as release
COPY --from=build /opt/venv /opt/venv
ADD app/main.py /app/main.py
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /

EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
# CMD . /opt/venv/bin/activate && exec python main.py
