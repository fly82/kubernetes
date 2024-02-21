```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.29.2@sha256:acc9e82a5a5bd3dfccfd03117e9ef5f96b46108b55cd647fb5e7d0d1a35c9c6f
  extraPortMappings:
    - containerPort: 30000
      hostPort: 30000
      listenAddress: "0.0.0.0"
      protocol: tcp
- role: worker
  image: kindest/node:v1.29.2@sha256:acc9e82a5a5bd3dfccfd03117e9ef5f96b46108b55cd647fb5e7d0d1a35c9c6f
    #networking:
    #disableDefaultCNI: false
    #podSubnet: "10.0.0.0/16"
    #serviceSubnet: "10.1.0.0/16"
```
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.22.0/kind-linux-amd64
kind create cluster --name c1 --config kind-c1.yaml
```
