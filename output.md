------------------------------------
./elera-eu-colruyt/values.yaml
imagePullSecrets:
image: elera-platform-admin-ui-all-eu
imageTag: 1.19.1
image: platform
imageTag: 1.19.0
imageLayered: true
image: elera-client
imageTag: 0.18.0
image: elera-client-nginx
imageTag: 1.4.0
image: data-loader
imageTag: 1.19.0
imageLayered: false
------------------------------------
./tomcat/values.yaml
image: ingress
imageTag: 1.4.0
image: platform
imageTag: 1.6.0
------------------------------------
./apache/values.yaml
image: nginx
imageTag: 1.4.1
# Overrides the image tag whose default is the chart appVersion.
#imageTag: 1.4.1
#imagePullSecrets: []
