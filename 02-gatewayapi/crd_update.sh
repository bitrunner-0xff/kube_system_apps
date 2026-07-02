crds=("GRPCRoutes" "ReferenceGrants")

for crd in "${crds[@]}"; do
    output=$(kubectl get "${crd}" -A -o json)

    echo "$output" | jq -c '.items[]' | while IFS= read -r resource; do
        namespace=$(echo "$resource" | jq -r '.metadata.namespace')
        name=$(echo "$resource" | jq -r '.metadata.name')
        kubectl patch "${crd}" "${name}" -n "${namespace}" --type='json' -p='[{"op": "replace", "path": "/metadata/annotations/migration-time", "value": "'"$(date +%Y-%m-%dT%H:%M:%S)"'" }]'
    done
done
