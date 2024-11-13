import yaml
import docker
from pathlib import Path

def should_download_image(config):
    if isinstance(config, dict):
        if 'enabled' in config:
            return config['enabled']
        if 'image' in config:
            return should_download_image(config['image'])
    return True

def get_full_image_name(image_config):
    registry = image_config.get('registry', '')
    repository = image_config.get('repository', '')
    tag = image_config.get('tag', 'latest')
    digest = image_config.get('digest', '')

    full_name = f"{registry}/{repository}:{tag}" if registry else f"{repository}:{tag}"
    if digest:
        full_name += f"@{digest}"
    return full_name

def download_images(config):
    client = docker.from_env()

    for key, value in config.items():
        if isinstance(value, dict) and 'image' in value:
            if should_download_image(value):
                image_config = value['image']
                full_image_name = get_full_image_name(image_config)
                print(f"Downloading image: {full_image_name}")
                try:
                    client.images.pull(full_image_name)
                    print(f"Successfully downloaded: {full_image_name}")
                except docker.errors.ImageNotFound:
                    print(f"Image not found: {full_image_name}")
                except Exception as e:
                    print(f"Error downloading {full_image_name}: {str(e)}")
        elif isinstance(value, dict):
            download_images(value)

def main():
    config_file = Path("config-jenkins.yaml")

    if not config_file.exists():
        print(f"Config file not found: {config_file}")
        return

    with open(config_file, 'r') as file:
        config = yaml.safe_load(file)

    download_images(config)

if __name__ == "__main__":
    main()
