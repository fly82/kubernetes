kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/experimental/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.4.1/config/crd/standard/gateway.networking.k8s.io_backendtlspolicies.yaml
cilium install --version 1.18.5 \
    --set kubeProxyReplacement=true \
    --set gatewayAPI.enabled=true \
    --set envoy.securityContext.capabilities.keepCapNetBindService=true \
    --set l2announcements.enabled=true \
    --set enableIPv4Masquerade=false \
    --set enableIPv6Masquerade=false \
    --set ipam.mode=kubernetes
kubectl wait \
	--namespace kube-system \
	--for=condition=ready pod \
	--selector=k8s-app=cilium \
	--timeout=90s
kubectl wait \
	--namespace kube-system \
	--for=condition=ready pod \
	--selector=k8s-app=cilium-envoy \
	--timeout=90s
kubectl apply -f gateway-class.yaml
kubectl apply -f announce.yaml
KIND_NET_CIDR=$(docker network inspect kind -f '{{(index .IPAM.Config 0).Subnet}}')
export METALLB_IP_BEGIN=$(echo ${KIND_NET_CIDR} | sed "s@0.0/16@255.200@")
export METALLB_IP_END=$(echo ${KIND_NET_CIDR} | sed "s@0.0/16@255.250@")
envsubst < ip-pool.yaml.tpl | kubectl apply -f -
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/httpbin/httpbin.yaml
kubectl apply -f gw.yaml
exit 0
export INGRESS_HOST=$(kubectl get gateways.gateway.networking.k8s.io gateway -n gateway -ojsonpath='{.status.addresses[0].value}')
curl -s -I -HHost:httpbin.example.com "http://$INGRESS_HOST/get"
