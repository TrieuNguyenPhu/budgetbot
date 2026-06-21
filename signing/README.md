# Image signing key

The committed `cosign.pub` is the admission verification key. The matching local private key was deleted. Generate the production pair with `cosign generate-key-pair`, update the public key in `policies/cluster-image-policy.yaml`, and store only the private key and password as GitHub Actions secrets `COSIGN_PRIVATE_KEY` and `COSIGN_PASSWORD`.
