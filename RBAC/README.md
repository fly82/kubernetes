#### Generating the user's SSL key:
```
openssl genrsa -out vadym.key 4096
```
#### Generate a certificate request:
```
openssl req -config csr.cnf -new -key vadym.key -nodes -out vadym.csr
```
#### Certificate request in base64 format:
```
export BASE64_CSR=$(cat vadym.csr | base64 | tr -d '\n')
```
#### Sign request step 1
```
cat > csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: vadym_csr
spec:
  groups:
  - system:authenticated
  request: ${BASE64_CSR}
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
```
#### Sign request step 2
```
cat csr.yaml | envsubst | kubectl apply -f -
```
#### We sign and generate a certificate:
```
kubectl certificate approve vadym_csr
```
#### Copy the ~/.kube/config file to the temporary directory and delete the client-certificate-data and client-key-data lines from it in the users section:
```
echo "client-certificate-data: $(kubectl get csr vadym_csr -o jsonpath={.status.certificate})" >> config
```
#### Change the user to vadym:
```
kubectl --kubeconfig ./config config set-credentials vadym --client-key=vadym.key --embed-certs=true
```
#### Let's look at the resulting configuration file:
```
kubectl --kubeconfig ./config config view
```
