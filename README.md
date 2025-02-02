```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.25.0/kind-linux-amd64
```
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.32.1@sha256:6afef2b7f69d627ea7bf27ee6696b6868d18e03bf98167c420df486da4662db6
  #extraPortMappings:
  #  - containerPort: 30000
  #    hostPort: 30000
  #    listenAddress: "0.0.0.0"
  #    protocol: tcp
- role: worker
  image: kindest/node:v1.32.1@sha256:6afef2b7f69d627ea7bf27ee6696b6868d18e03bf98167c420df486da4662db6
networking:
  disableDefaultCNI: false
  #kubeProxyMode: "none"
  podSubnet: "10.0.0.0/16"
  serviceSubnet: "10.1.0.0/16"
```
```bash
kind create cluster --name c1 --config kind-c1.yaml
```
