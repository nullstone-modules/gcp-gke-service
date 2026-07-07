# Google Kubernetes Engine Service

This app module is used to create a long-running service such as an API, Web App, or Background Worker.

## When to use

GKE Service is a great choice for APIs, Web Apps, or Background Workers and you do not want to manage a Kubernetes cluster.

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/gcp-gke-service/hipaa)

## Platform

This module uses [GCP GKE](https://cloud.google.com/kubernetes-engine), which is a technology that allows you to run Kubernetes container applications without managing servers. 

## Network Access

When the service is provisioned, it is placed into private subnets on the connected network.
As a result, the Fargate Service can route to services on the private network *and* is accessible on the private network.

## Public Access

To enable public access to the service, add an `Ingress` capability.

In most cases, a `Load Balancer` capability is the best choice for exposing as it enables rollout deployments with no downtime.
Additionally, a `Load Balancer` allows you to split traffic between more than 1 task based on load.

## Zero-downtime rollouts

The Deployment uses a rolling update strategy of `maxSurge: 1`, `maxUnavailable: 0` by default (via `var.rolling_update_strategy`) so capacity is never reduced mid-rollout. Set `var.rolling_update_strategy = null` to fall back to the Kubernetes default (25% surge / 25% unavailable):

```hcl
rolling_update_strategy = {
  max_surge       = "1"
  max_unavailable = "0"
}
```

When a `Load Balancer` capability is attached, the Deployment additionally configures pod termination to avoid the brief downtime that container-native (NEG) load balancing can cause during rollouts (`connection termination` / `no healthy upstream`). The load balancer module supplies a `deployment_overrides` bundle that sets:

- A container `preStop` sleep that holds the listener open while the load balancer deprograms the terminating endpoint.
- `terminationGracePeriodSeconds`, sized to cover the `preStop` sleep plus an application drain buffer.

With no Load Balancer attached — or when the load balancer disables coordination — pod termination uses Kubernetes defaults.

The app's own `var.termination_grace_seconds` (default 30) sets a floor for the grace period; when a capability also supplies a termination grace override, the larger of the two values wins. Raise it for apps that need time to finish in-flight work on shutdown (e.g. model servers draining long-running requests).

When `replicas >= 2`, the module also emits a PodDisruptionBudget with `minAvailable: replicas - 1` so voluntary disruptions (node drains, node pool upgrades) can never take down the last ready replica.

## GPU workloads

Attach the `gcp-gke-gpu-cores` capability (paired with a `gcp-gke-gpu-node-pool` block) to allocate `nvidia.com/gpu` slots, schedule onto the GPU node pool, and tolerate the GPU taint. Capabilities can contribute `resource_limits`, `node_selectors`, `tolerations`, and `topology_spread_constraints` outputs; topology spread constraints automatically receive this app's pod selector.

For GPU apps on a full node pool (no spare GPU slot for a surge pod), set:

```hcl
rolling_update_strategy = {
  max_surge       = "0"
  max_unavailable = "1"
}
```

### Handling SIGTERM in your application

The `preStop` sleep and grace period only create the window for a graceful shutdown — your application must still stop accepting new work and finish in-flight requests when it receives `SIGTERM`. Examples:

- **Go** – `signal.NotifyContext(ctx, syscall.SIGTERM)`, then `server.Shutdown(ctx)`.
- **Node.js (Express)** – `process.on('SIGTERM', () => server.close(...))`.
- **Python (Gunicorn/Uvicorn)** – both perform a graceful worker shutdown on `SIGTERM` by default; ensure your handlers return promptly.
- **Java (Spring Boot)** – enable `server.shutdown=graceful` and set `spring.lifecycle.timeout-per-shutdown-phase`.

For long-lived connections (websockets, SSE), raise the load balancer's `app_drain_seconds` so the grace period covers your longest acceptable drain.

## Logs

Logs are automatically emitted to AWS Cloudwatch Log Group: `/<task-name>`.
To access through the Nullstone CLI, use `nullstone logs` CLI command. (See [`logs`](https://docs.nullstone.io/getting-started/cli/docs.html#logs) for more information)

## Backend Policy

This module creates a `GCPBackendPolicy` for the Service. The `backend_policy` variable controls:

- **Timeout** – Backend request timeout in seconds (default: 30s).
- **Connection draining** – Graceful draining timeout for removed backends.
- **Session affinity** – Sticky sessions by type (`NONE`, `CLIENT_IP`, `GENERATED_COOKIE`, etc.) with optional cookie TTL.
- **Access logging** – Whether to log requests and at what sample rate (enabled by default to preserve GKE defaults).

See [Configure Gateway resources using Policies](https://docs.cloud.google.com/kubernetes-engine/docs/how-to/configure-gateway-resources) for full details.

## Secrets

Nullstone automatically injects secrets into your GKE Service through environment variables.
(They are stored in GCP Secrets Manager and injected by Kubernetes during launch.)

## File system

The root file system is configured to be read-only to prevent an attacker from making permanent local changes and prevents binaries from being written to the local filesystem.
To create a persistent file system, add a `Datastore` to attach volumes or object storage.
