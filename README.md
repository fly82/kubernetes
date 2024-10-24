```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.31.1@sha256:cd224d8da58d50907d1dd41d476587643dad2ffd9f6a4d96caf530fb3b9a5956
  extraPortMappings:
    - containerPort: 30000
      hostPort: 30000
      listenAddress: "0.0.0.0"
      protocol: tcp
- role: worker
  image: kindest/node:v1.31.1@sha256:cd224d8da58d50907d1dd41d476587643dad2ffd9f6a4d96caf530fb3b9a5956
    #networking:
    #disableDefaultCNI: false
    #podSubnet: "10.0.0.0/16"
    #serviceSubnet: "10.1.0.0/16"
```
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.22.0/kind-linux-amd64
kind create cluster --name c1 --config kind-c1.yaml
```
