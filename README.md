```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.31.2@sha256:18fbefc20a7113353c7b75b5c869d7145a6abd6269154825872dc59c1329912e
  #extraPortMappings:
  #  - containerPort: 30000
  #    hostPort: 30000
  #    listenAddress: "0.0.0.0"
  #    protocol: tcp
- role: worker
  image: kindest/node:v1.31.2@sha256:18fbefc20a7113353c7b75b5c869d7145a6abd6269154825872dc59c1329912e
networking:
  disableDefaultCNI: false
  podSubnet: "10.0.0.0/16"
  serviceSubnet: "10.1.0.0/16"
```
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.25.0/kind-linux-amd64
kind create cluster --name c1 --config kind-c1.yaml
```
