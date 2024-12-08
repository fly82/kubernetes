kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml
kubectl wait \
	--namespace metallb-system \
	--for=condition=ready pod \
	--selector=app=metallb \
	--timeout=90s
docker network inspect -f '{{.IPAM.Config}}' kind
kubectl apply -f metallb.yaml
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null ||   { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.2.1" | kubectl apply -f -; }
istioctl install --set profile=minimal -y
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/httpbin/httpbin.yaml
kubectl create namespace istio-ingress
kubectl apply -f gw.yaml
exit 0
export INGRESS_HOST=$(kubectl get gateways.gateway.networking.k8s.io gateway -n istio-ingress -ojsonpath='{.status.addresses[0].value}')
curl -s -I -HHost:httpbin.example.com "http://$INGRESS_HOST/get"
curl -s -I -HHost:httpbin.example.com "http://$INGRESS_HOST/headers"
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: http
  namespace: default
spec:
  parentRefs:
  - name: gateway
    namespace: istio-ingress
  hostnames: ["httpbin.example.com"]
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /get
    - path:
        type: PathPrefix
        value: /headers
    filters:
    - type: RequestHeaderModifier
      requestHeaderModifier:
        add:
        - name: my-added-header
          value: added-value
    backendRefs:
    - name: httpbin
      port: 8000
EOF

curl -s -HHost:httpbin.example.com "http://$INGRESS_HOST/headers" | jq '.headers["My-Added-Header"][0]'

