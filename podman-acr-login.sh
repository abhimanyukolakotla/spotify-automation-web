TOKEN=$(az acr login --name sbconsdevregistry --expose-token --output json | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")
echo $TOKEN | podman login sbconsdevregistry.azurecr.io -u 00000000-0000-0000-0000-000000000000 --password-stdin

#consumer-cloud-migration