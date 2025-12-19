```bash
wget https://github.com/cilium/cilium-cli/releases/download/v0.18.8/cilium-linux-amd64.tar.gz
tar -xf cilium-linux-amd64.tar.gz
```
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.35.0@sha256:4613778f3cfcd10e615029370f5786704559103cf27bef934597ba562b269661
  #extraPortMappings:
  #  - containerPort: 30000
  #    hostPort: 30000
  #    listenAddress: "0.0.0.0"
  #    protocol: tcp
- role: worker
  image: kindest/node:v1.35.0@sha256:4613778f3cfcd10e615029370f5786704559103cf27bef934597ba562b269661
networking:
  disableDefaultCNI: true
  kubeProxyMode: "none"
  podSubnet: "10.0.0.0/16"
  serviceSubnet: "10.1.0.0/16"
```
```bash
kind create cluster --name c1 --config kind-c1.yaml
```
