#!/bin/bash
# Kubernetes Full Cluster Inspection Script

# Function to display section headers
section_header() {
  echo "-----------------------------------------------------------------------"
  echo "$1"
  echo "-----------------------------------------------------------------------"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check node status
check_node_status() {
  section_header "Node Status Check"
  kubectl get nodes
}

# Function to check pod health
check_pod_health() {
  section_header "Pod Health Check"
  kubectl get pods --all-namespaces
}

# Function to check service and ingress
check_service_ingress() {
  section_header "Service and Ingress Check"
  kubectl get svc,ingress --all-namespaces
}

# Function to check storage and persistent volume
check_storage_pv() {
  section_header "Storage and Persistent Volume Check"
  kubectl get pv,pvc --all-namespaces
}

# Function to check network and network policies
check_network_policies() {
  section_header "Network and Network Policies Check"
  kubectl get networkpolicies --all-namespaces
}

# Function to check RBAC and security
check_rbac_security() {
  section_header "RBAC and Security Check"
  kubectl get rolebindings,roles,clusterrolebindings,clusterroles --all-namespaces
}

# Function to check autoscaling
check_autoscaling() {
  section_header "Autoscaling Check"
  kubectl get hpa --all-namespaces
}

# Function to check monitoring and logging
check_monitoring_logging() {
  section_header "Monitoring and Logging Check"
  kubectl get pods --namespace monitoring
  kubectl get pods --namespace logging
}

# Function to check backup and disaster recovery
check_backup_recovery() {
  section_header "Backup and Disaster Recovery Check"
  # Add your backup and recovery checks here
}

# Function to check Kubernetes version and updates
check_k8s_version_updates() {
  section_header "Kubernetes Version and Updates Check"
  kubectl version
  # Add your update checks here
}

# Function to check resource limits and quotas
check_resource_limits_quotas() {
  section_header "Resource Limits and Quotas Check"
  kubectl get resourcequotas,limitranges --all-namespaces
}

# Function to check pod and deployment policies
check_pod_deployment_policies() {
  section_header "Pod and Deployment Policies Check"
  kubectl get pods,deployments,statefulsets --all-namespaces
}

# Function to check log and audit
check_log_audit() {
  section_header "Log and Audit Check"
  # Add your log and audit checks here
}

# Main script
echo "Kubernetes Full Cluster Inspection"
echo "Date: $(date)"

# Check kubectl installation
if ! command_exists kubectl; then
  echo "kubectl not found. Please install kubectl."
  exit 1
fi

# Perform checks
check_node_status
check_pod_health
check_service_ingress
check_storage_pv
check_network_policies
check_rbac_security
check_autoscaling
check_monitoring_logging
check_backup_recovery
check_k8s_version_updates
check_resource_limits_quotas
check_pod_deployment_policies
check_log_audit

echo "Kubernetes Full Cluster Inspection completed."
