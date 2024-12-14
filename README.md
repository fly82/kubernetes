```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.32.0@sha256:c48c62eac5da28cdadcf560d1d8616cfa6783b58f0d94cf63ad1bf49600cb027
  #extraPortMappings:
  #  - containerPort: 30000
  #    hostPort: 30000
  #    listenAddress: "0.0.0.0"
  #    protocol: tcp
- role: worker
  image: kindest/node:v1.32.0@sha256:c48c62eac5da28cdadcf560d1d8616cfa6783b58f0d94cf63ad1bf49600cb027
networking:
  disableDefaultCNI: false
  #kubeProxyMode: "none"
  podSubnet: "10.0.0.0/16"
  serviceSubnet: "10.1.0.0/16"
```
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.25.0/kind-linux-amd64
kind create cluster --name c1 --config kind-c1.yaml
```
