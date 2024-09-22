```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.30.4@sha256:976ea815844d5fa93be213437e3ff5754cd599b040946b5cca43ca45c2047114
  extraPortMappings:
    - containerPort: 30000
      hostPort: 30000
      listenAddress: "0.0.0.0"
      protocol: tcp
- role: worker
  image: kindest/node:v1.30.4@sha256:976ea815844d5fa93be213437e3ff5754cd599b040946b5cca43ca45c2047114
    #networking:
    #disableDefaultCNI: false
    #podSubnet: "10.0.0.0/16"
    #serviceSubnet: "10.1.0.0/16"
```
```bash
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.22.0/kind-linux-amd64
kind create cluster --name c1 --config kind-c1.yaml
```
