apiVersion: cilium.io/v2alpha1
kind: CiliumLoadBalancerIPPool
metadata:
  name: first-pool
spec:
  blocks:
    - start: ${METALLB_IP_BEGIN}
      stop: ${METALLB_IP_END}
