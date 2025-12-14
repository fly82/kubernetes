# Download from https://github.com/kubernetes-sigs/kind/releases
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.30.0/kind-linux-amd64
```
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.34.2@sha256:745f8ed46d8e99517774768227fd1a0af34a6bf395aef9c7ed98fbce0e263918
  #extraPortMappings:
  #  - containerPort: 30000
  #    hostPort: 30000
  #    listenAddress: "0.0.0.0"
  #    protocol: tcp
- role: worker
  image: kindest/node:v1.34.2@sha256:745f8ed46d8e99517774768227fd1a0af34a6bf395aef9c7ed98fbce0e263918
networking:
  disableDefaultCNI: false
  #kubeProxyMode: "none"
  podSubnet: "10.0.0.0/16"
  serviceSubnet: "10.1.0.0/16"
```
```bash
kind create cluster --name c1 --config kind-c1.yaml
```
