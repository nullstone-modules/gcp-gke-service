# gcp-gke-service
Nullstone module to launch a GKE container on GCP.

## Inputs

- `service_name: string`
  - Name of service.
  - Default: `""`

- `service_memory: string`
  - Allocated memory to pods.
  - Default: `"512Mi"`

- `service_cpu: string`
  - Allocated cpu to pods.
  - Default: `"0.5"`

- `pods_replica_count: number`
  - The number of desired pods replicas.
  - Default: `1`

- `container_port: number`
  - The port that will be exposed by this service.
  - Default: `80`

- `lb_port: number`
  - The port to access on the pods targeted by the service.
  - Default: `80`

- `enable_lb: bool`
  - Enable this to add a load balancer service.
  - Default: `true`

## Outputs

- `service_image: string` 
  - Service container image url.
  
- `lb_ip: string` 
  - IP address of load balancer.

- `cluster_ca_certificate: string` 
  - Base64 encoded public certificate used by clients to authenticate to the cluster endpoint.