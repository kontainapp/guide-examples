# good articles on autoscale
setup and use: https://knative.dev/docs/getting-started/quickstart-install/
gVisor knative setup: https://gvisor.dev/docs/tutorials/knative/

## code samples
Serving code samples: https://knative.dev/development/samples/serving/
Go code: https://github.com/knative/docs/tree/main/code-samples/serving/hello-world/helloworld-go
Java(spring): https://github.com/knative/docs/tree/main/code-samples/serving/hello-world/helloworld-java-spring
Python: https://github.com/knative/docs/tree/main/code-samples/serving/hello-world/helloworld-java-spark

## Articles
serving metrics: https://knative.dev/docs/serving/observability/metrics/serving-metrics/#activator
scaling: https://github.com/knative/serving/blob/main/docs/roadmap/scaling-2019.md
SEE This for startup time issues: https://github.com/knative/serving/issues/1297
            more details at: https://github.com/knative/serving/issues/1297#issuecomment-401058968
kourier: https://developers.redhat.com/blog/2020/06/30/kourier-a-lightweight-knative-serving-ingress
k8s to knative deployment: https://www.redhat.com/sysadmin/kubernetes-deployment-knative-service

sslip.io for DNS: https://tanzu.vmware.com/content/blog/sslip-io-a-valid-ssl-certificate-for-every-ip-address

## TO DELETE
```shell
$ kubectl delete -f # does not seem to be enough
$ kn service delete <service-name>
```

## install
NOTE - REMEMBER TO DOWNLOAD MOST RECENT VERSION of KIND

download
https://github.com/knative-sandbox/kn-plugin-quickstart/releases/tag/knative-v1.3.1

1. download and install kn
2. download and isntall kn-quickstart
3. run $ kn plugin list 
to check if its installed
4. $ kn quickstart kind
to start a cluster

```shell
# download kind CLI
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# download knative client cli - kn
wget https://github.com/knative/client/releases/download/knative-v1.3.1/kn-linux-amd64
chmod +x kn-linux-amd64
sudo mv kn-linux-amd64 /usr/local/bin/kn

# add quick start plugin for kind
wget https://github.com/knative-sandbox/kn-plugin-quickstart/releases/download/knative-v1.3.1/kn-quickstart-linux-amd64
chmod +x ./kn-quickstart-linux-amd64
sudo mv ./kn-quickstart-linux-amd64 /usr/local/bin/kn-quickstart

# verify that the plugin is present
$ kn plugins list
- kn-quickstart : /usr/local/bin/kn-quickstart

# create a kind cluster with knative
$ kn quickstart kind
...
...
Ready after 19s 💚
Set kubectl context to "kind-knative"
You can now use your cluster with:

kubectl cluster-info --context kind-knative

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/

🍿 Installing Knative Serving v1.3.0 ...
    CRDs installed...
    Core installed...
    Finished installing Knative Serving
🕸️ Installing Kourier networking layer v1.3.0 ...
    Kourier installed...
    Ingress patched...
    Finished installing Kourier Networking layer
🕸 Configuring Kourier for Kind...
    Kourier service installed...
    Domain DNS set up...
    Finished configuring Kourier
🔥 Installing Knative Eventing v1.3.0 ...
    CRDs installed...
    Core installed...
    In-memory channel installed...
    Mt-channel broker installed...
    Example broker installed...
    Finished installing Knative Eventing
🚀 Knative install took: 2m14s
🎉 Now have some fun with Serverless and Event Driven Apps!
```

# Deploy hello world
```shell
kn service create hello \
--image gcr.io/knative-samples/helloworld-go \
--port 8080 \
--env TARGET=World \
--revision-name=world

 or

 apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello
spec:
  template:
    metadata:
      # This is the name of our new "Revision," it must follow the convention {service-name}-{revision-name}
      name: hello-world
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go
          ports:
            - containerPort: 8080
          env:
            - name: TARGET
              value: "World"


$ kubectl apply -f hello.yaml
service.serving.knative.dev/hello created

# To see the URL where your Knative Service is hosted, leverage the kn CLI:

# to see URL
kn service list
NAME    URL                                       LATEST        AGE   CONDITIONS   READY   REASON
hello   http://hello.default.127.0.0.1.sslip.io   hello-world   92s   3 OK / 3     True

# ping it
$ curl http://hello.default.127.0.0.1.sslip.io
Hello World!

# scale to 0
# after 2 minutes it starts auto-shutting down
$ kubectl get pod -l serving.knative.dev/service=hello -w
........... terminating


$ curl http://hello.default.127.0.0.1.sslip.io
- after 1.6 seconds

........... 2/2 Container Creating
........... 2/2 Running
```

# For, traffic-splitting use this
https://knative.dev/docs/getting-started/first-traffic-split/#list-your-revisions

```shell
$ kn revisions list
```

# add a runtime class (like gVisor)
https://gvisor.dev/docs/tutorials/knative/

Knative allows the use of various parameters on Pods via feature flags. We will enable the runtimeClassName feature flag to enable the use of the Kubernetes Runtime Class.

Edit the feature flags ConfigMap.

```shell
kubectl edit configmap config-features -n knative-serving
```

Add the kubernetes.podspec-runtimeclassname: enabled to the data field. Once you are finished the ConfigMap will look something like this (minus all the system fields).

# describe knative pod
```shell
kubectl describe po/hello-world-deployment-6cdd9cddcd-thwmc
Name:         hello-world-deployment-6cdd9cddcd-thwmc
Namespace:    default
Priority:     0
Node:         knative-control-plane/172.19.0.2
Start Time:   Fri, 25 Mar 2022 14:45:50 -0700
Labels:       app=hello-world
              pod-template-hash=6cdd9cddcd
              serving.knative.dev/configuration=hello
              serving.knative.dev/configurationGeneration=1
              serving.knative.dev/configurationUID=228b1bc0-8308-4906-bb34-51a7e36ab644
              serving.knative.dev/revision=hello-world
              serving.knative.dev/revisionUID=12cc4ff1-891f-40b1-bc50-25ddeaae7a40
              serving.knative.dev/service=hello
              serving.knative.dev/serviceUID=c31c6a6c-303e-416f-8abb-cda58275f59c
Annotations:  serving.knative.dev/creator: kubernetes-admin
Status:       Running
IP:           10.244.0.36
IPs:
  IP:           10.244.0.36
Controlled By:  ReplicaSet/hello-world-deployment-6cdd9cddcd
Containers:
  user-container:
    Container ID:   containerd://492eb6ea5105f78289ae291408519d8bac309b861d522750a1becdf63b8888a8
    Image:          gcr.io/knative-samples/helloworld-go@sha256:5ea96ba4b872685ff4ddb5cd8d1a97ec18c18fae79ee8df0d29f446c5efe5f50
    Image ID:       gcr.io/knative-samples/helloworld-go@sha256:5ea96ba4b872685ff4ddb5cd8d1a97ec18c18fae79ee8df0d29f446c5efe5f50
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 25 Mar 2022 14:45:51 -0700
    Ready:          True
    Restart Count:  0
    Environment:
      TARGET:           World
      PORT:             8080
      K_REVISION:       hello-world
      K_CONFIGURATION:  hello
      K_SERVICE:        hello
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-fjsvk (ro)
  queue-proxy:
    Container ID:   containerd://399a9dee99bd5f3115786d7e96bc86b5c248404bf55a7faabd6a5f192fffc5f7
    Image:          gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:c9dcb1610c99fab4caa39b972f6ce4defa2bdc4ab5c502cc1759f6aa89c34e02
    Image ID:       gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:c9dcb1610c99fab4caa39b972f6ce4defa2bdc4ab5c502cc1759f6aa89c34e02
    Ports:          8022/TCP, 9090/TCP, 9091/TCP, 8012/TCP
    Host Ports:     0/TCP, 0/TCP, 0/TCP, 0/TCP
    State:          Running
      Started:      Fri, 25 Mar 2022 14:45:51 -0700
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:      25m
    Readiness:  http-get http://:8012/ delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:
      SERVING_NAMESPACE:                 default
      SERVING_SERVICE:                   hello
      SERVING_CONFIGURATION:             hello
      SERVING_REVISION:                  hello-world
      QUEUE_SERVING_PORT:                8012
      CONTAINER_CONCURRENCY:             0
      REVISION_TIMEOUT_SECONDS:          300
      SERVING_POD:                       hello-world-deployment-6cdd9cddcd-thwmc (v1:metadata.name)
      SERVING_POD_IP:                     (v1:status.podIP)
      SERVING_LOGGING_CONFIG:
      SERVING_LOGGING_LEVEL:
      SERVING_REQUEST_LOG_TEMPLATE:      {"httpRequest": {"requestMethod": "{{.Request.Method}}", "requestUrl": "{{js .Request.RequestURI}}", "requestSize": "{{.Request.ContentLength}}", "status": {{.Response.Code}}, "responseSize": "{{.Response.Size}}", "userAgent": "{{js .Request.UserAgent}}", "remoteIp": "{{js .Request.RemoteAddr}}", "serverIp": "{{.Revision.PodIP}}", "referer": "{{js .Request.Referer}}", "latency": "{{.Response.Latency}}s", "protocol": "{{.Request.Proto}}"}, "traceId": "{{index .Request.Header "X-B3-Traceid"}}"}
      SERVING_ENABLE_REQUEST_LOG:        false
      SERVING_REQUEST_METRICS_BACKEND:   prometheus
      TRACING_CONFIG_BACKEND:            none
      TRACING_CONFIG_ZIPKIN_ENDPOINT:
      TRACING_CONFIG_DEBUG:              false
      TRACING_CONFIG_SAMPLE_RATE:        0.1
      USER_PORT:                         8080
      SYSTEM_NAMESPACE:                  knative-serving
      METRICS_DOMAIN:                    knative.dev/internal/serving
      SERVING_READINESS_PROBE:           {"tcpSocket":{"port":8080,"host":"127.0.0.1"},"successThreshold":1}
      ENABLE_PROFILING:                  false
      SERVING_ENABLE_PROBE_REQUEST_LOG:  false
      METRICS_COLLECTOR_ADDRESS:
      CONCURRENCY_STATE_ENDPOINT:
      CONCURRENCY_STATE_TOKEN_PATH:      /var/run/secrets/tokens/state-token
      HOST_IP:                            (v1:status.hostIP)
      ENABLE_HTTP2_AUTO_DETECTION:       false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-fjsvk (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-fjsvk:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  111s  default-scheduler  Successfully assigned default/hello-world-deployment-6cdd9cddcd-thwmc to knative-control-plane
  Normal  Pulled     110s  kubelet            Container image "gcr.io/knative-samples/helloworld-go@sha256:5ea96ba4b872685ff4ddb5cd8d1a97ec18c18fae79ee8df0d29f446c5efe5f50" already present on machine
  Normal  Created    110s  kubelet            Created container user-container
  Normal  Started    110s  kubelet            Started container user-container
  Normal  Pulled     110s  kubelet            Container image "gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:c9dcb1610c99fab4caa39b972f6ce4defa2bdc4ab5c502cc1759f6aa89c34e02" already present on machine
  Normal  Created    110s  kubelet            Created container queue-proxy
  Normal  Started    110s  kubelet            Started container queue-proxy
```


# ADD KONTAIN RUNTIME CLASS
By default, the knative admission controller does not allow use "runtime"

```shell
$ kubectl edit configmap config-features -n knative-serving

# in nano make sure that below data element, you add the following stanza (ignore the _example stuff)
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-features
  namespace: knative-serving
  labels:
    serving.knative.dev/release: v0.22.0
data:
  kubernetes.podspec-runtimeclassname: enabled


# now, add the Kontain runtime class to Kubernetes
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/km.yaml

# after some time:
$ kubectl get runtimeclass
NAME      HANDLER   AGE
kontain   krun      17h
```