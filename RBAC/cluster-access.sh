#!/bin/bash

USER=${1:-test}
# Creation of a Private Key and a Certificate Signing Request (CSR)
openssl genrsa -out ${USER}.key 4096

# 
cat <<EOF > csr.cnf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
[ dn ]
CN = ${USER}
O = dev
[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
EOF

openssl req \
  -config ./csr.cnf \
  -new -key ${USER}.key \
  -nodes -out ${USER}.csr

cat <<EOF > csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: mycsr
spec:
  groups:
  - system:authenticated
  request: \${BASE64_CSR}
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
EOF

# Encoding the .csr file in base64
export BASE64_CSR=$(cat ./${USER}.csr | base64 | tr -d '\n')

echo ${BASE64_CSR}

# Substitution of the BASE64_CSR env variable and creation of the CertificateSigninRequest resource
cat csr.yaml | envsubst | kubectl apply -f -

# Check
k get csr

# Approve
kubectl certificate approve mycsr

# Extract Certificate
kubectl get csr mycsr -o jsonpath='{.status.certificate}' \
  | base64 --decode > ${USER}.crt

# Show Certificate Information
openssl x509 -in ./${USER}.crt -noout -text

# Create a Namespace
kubectl create ns development

k config set-context --current --namespace=development

cat <<EOF > role.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: development
  name: dev
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["create", "get", "update", "list", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create", "get", "update", "list", "delete"]
EOF

kubectl apply -f role.yaml

cat <<EOF > role-binding.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev
  namespace: development
subjects:
- kind: User
  name: ${USER}
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: dev
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl apply -f role-binding.yaml

cat <<EOF > kubeconfig.tpl
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: \${CERTIFICATE_AUTHORITY_DATA}
    server: \${CLUSTER_ENDPOINT}
  name: \${CLUSTER_NAME}
users:
- name: \${USER}
  user:
    client-certificate-data: \${CLIENT_CERTIFICATE_DATA}
contexts:
- context:
    cluster: \${CLUSTER_NAME}
    user: ${USER}
  name: \${USER}-\${CLUSTER_NAME}
current-context: \${USER}-\${CLUSTER_NAME}
EOF

# User identifier
export USER="${USER}"
export CLUSTER_NAME=$(kubectl config current-context | awk -F "@" '{ print $2 }')
export CLIENT_CERTIFICATE_DATA=$(kubectl get csr mycsr -o jsonpath='{.status.certificate}')

# Base Command to Extract "server" and "cluster.certificate-authority-data"
BASE_COMMAND="kubectl config view -o jsonpath='{.clusters[?(@.name==\"%s\")].cluster.%s}' --raw"

# Cluster Certificate Authority and API Server endpoint
COMMAND=$(printf "${BASE_COMMAND}" "${CLUSTER_NAME}" "certificate-authority-data") && export CERTIFICATE_AUTHORITY_DATA=$(${COMMAND} | tr -d "'")
COMMAND=$(printf "${BASE_COMMAND}" "${CLUSTER_NAME}" "server") && export CLUSTER_ENDPOINT=$(${COMMAND} | tr -d "'")

echo "USER........................: ${USER}" && \
echo "CLUSTER_NAME................: ${CLUSTER_NAME}" && \
echo "CLIENT_CERTIFICATE_DATA.....: ${#CLIENT_CERTIFICATE_DATA} (length)" && \
echo "CERTIFICATE_AUTHORITY_DATA..: ${#CERTIFICATE_AUTHORITY_DATA} (length)" && \
echo "CLUSTER_ENDPOINT............: ${CLUSTER_ENDPOINT}"

# View Template File
cat kubeconfig.tpl | yq r -

# Only show a template with values
cat kubeconfig.tpl | envsubst | yq r -

# Save it to a file
cat kubeconfig.tpl | envsubst > ${USER}_kubeconfig

# ${USER} should save the file as:
${HOME}/.kube/config

# And add his private key to it:
kubectl config set-credentials ${USER} \
  --client-key=$PWD/${USER}.key \
  --embed-certs=true
