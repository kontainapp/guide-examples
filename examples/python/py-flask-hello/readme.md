# reference
Docker python packaging: https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
For flask From: https://medium.com/analytics-vidhya/build-a-python-flask-app-and-deploy-with-kubernetes-ccc99bbec5dc
For compose from: https://takacsmark.com/docker-compose-tutorial-beginners-by-example-basics/
Extended: https://www.python4networkengineers.com/posts/python-intermediate/how_to_run_an_app_with_docker/

```bash
# build and run the container
$ docker build -t kg/pyflask .

#$ docker build --build-arg BUILD_IMAGE_VERSION=python:3.8-slim --build-arg KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python -t kg/pyflask .

$ docker run --runtime=krun -p 5000:5000 --rm kg/pyflask
# use Ctrl-\<enter> to exit the container

# run the http curl client in another shell terminal
$ curl -s -I http://localhost:5000/

# check size of image
$ docker images
python-slim........122MB
python-bullseye....915MB

# note the sizes of the Kontain python runtime image and 
#     the Python flask server Kontain container image
runenv-python......23.5MB
kg/pyflask.........40 MB
```

# Notes
The Dockerfile here uses a multi-stage docker build (https://pythonspeed.com/articles/multi-stage-docker-python/) for the following benefits:

* this allows us to use the traditional Docker build steps required for Python to install package requirements in a virtual environment as the preferred way to run Python applications
* allows us to copy over the virtual environment contents
* allows us to selectively copy over exactly the packaging requrements that Python would need to run the application
* the image size reduces from over a few hundred MB to about 40MB

# Docker Compose CLI
```bash
$ docker-compose build
$ docker-compose up
Recreating pyflask_app_1 ... done
Attaching to pyflask_app_1
app_1  | python: dlopen: failed to find registration for /opt/venv/lib64/python3.8/site-packages/markupsafe/_speedups.cpython-38-x86_64-linux-gnu.so, check if it was prelinked
app_1  |  * Serving Flask app 'main' (lazy loading)
app_1  |  * Environment: production
app_1  |    WARNING: This is a development server. Do not use it in a production deployment.
app_1  |    Use a production WSGI server instead.
app_1  |  * Debug mode: off
app_1  |  * Running on all addresses.
app_1  |    WARNING: This is a development server. Do not use it in a production deployment.
app_1  |  * Running on http://172.18.0.2:5000/ (Press CTRL+C to quit)
app_1  | 172.18.0.1 - - [02/Nov/2021 01:17:03] "GET / HTTP/1.1" 200 -


# in another window
$ curl http://localhost:5000/
Hello from Kontain!
```