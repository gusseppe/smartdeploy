import yaml

# Function to load YAML file
def load_yaml(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

# Function to write YAML file
def write_yaml(data, file_path):
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

# Load the existing Jenkins config YAML
config_file = 'config-jenkins.yaml'
jenkins_config = load_yaml(config_file)

# Update values as needed
jenkins_config['jenkinsUser'] = 'admin'
jenkins_config['jenkinsPassword'] = 'admin2024'

# Modify plugins list
jenkins_config['plugins'] = [
]

# Update persistence settings
jenkins_config['persistence'] = {
    'enabled': True,
    'storageClass': '',
    'accessModes': ['ReadWriteOnce'],
    'size': '10Gi'
}

# Update service settings (e.g., NodePort)
jenkins_config['service'] = {
    'type': 'NodePort',
    'ports': {'http': 8080, 'https': 8443},
    'nodePorts': {'http': 32000, 'https': 32001}
}

# Update resource limits for production
jenkins_config['resources'] = {
    'requests': {'cpu': '500m', 'memory': '1Gi'},
    'limits': {'cpu': '1', 'memory': '2Gi'}
}

# Write the updated config back to the YAML file
write_yaml(jenkins_config, config_file)

print(f"Updated {config_file} with your custom values.")

