# SmartFox Server Docker Image

This repository provides a Dockerfile to create a Docker image for [SmartFox Server 2X](https://www.smartfoxserver.com/).

## Usage

### Prerequisites

Make sure you have Docker installed on your system.

### Pulling the Docker Image

To pull the SmartFox Server Docker image from Docker Hub, use the following command:

```bash
docker pull dharmeshmp/smartfox:latest
```

This will fetch the latest version of the SmartFox Server Docker image.

### Running the Docker Container

To run the SmartFox Server Docker container, use the following command:

```bash
docker run -p 8080:8080 -p 8443:8443 -p 9933:9933 -p 9933:9933/udp -p 5000:5000 dharmeshmp/smartfox:latest
```

This will expose the necessary ports for SmartFox Server.

### Using Specific Versions

You can also use specific tags for different versions of SmartFox Server. For example, to use version 2.19.3, run:

```bash
docker pull dharmeshmp/smartfox:2.19.3

docker run -p 8080:8080 -p 8443:8443 -p 9933:9933 -p 9933:9933/udp -p 5000:5000 dharmeshmp/smartfox:2.19.3
```

### Docker Compose

If you prefer using Docker Compose, create a `docker-compose.yml` file with the following content:

```yaml
version: '3'
services:
  smartfox:
    image: dharmeshmp/smartfox:latest
    ports:
      - "8080:8080"
      - "8443:8443"
      - "9933:9933"
      - "9933:9933/udp"
      - "5000:5000"
```

Run the following command to start SmartFox Server using Docker Compose:

```bash
docker-compose up -d
```

This will start the SmartFox Server container in detached mode.

## Extending the Docker Image

You can extend the SmartFox Server Docker image to customize it for your specific requirements. Create a Dockerfile with the following content:

```Dockerfile
FROM dharmeshmp/smartfox:2.19.3

# Copy custom extension JAR file
COPY build/libs/*.jar /opt/SmartFoxServer_2X/SFS2X/extensions/Joker/extension.jar

# Copy custom zone configuration
COPY docker-smartfox/zones/Joker.zone.xml /opt/SmartFoxServer_2X/SFS2X/zones/Joker.zone.xml

# Copy custom server configuration
COPY docker-smartfox/config/server.xml /opt/SmartFoxServer_2X/SFS2X/config/server.xml

# Remove UploadsLock.txt to allow file uploads
RUN rm /opt/SmartFoxServer_2X/SFS2X/config/UploadsLock.txt
```

This example extends the base SmartFox Server image, adding custom extension JAR files, zone configurations, and server settings. Adjust it based on your specific requirements.

## Dockerfile Details

The Dockerfile uses [Amazon Corretto](https://aws.amazon.com/corretto/) as the base image for Java 8 Alpine and downloads and installs SmartFox Server 2X.

### Environment Variables

- `SFS_VERSION`: SmartFox Server version.
- `SFS_PATCH`: SmartFox Server patch version.

### Building for ARM

This Dockerfile supports ARM builds by using the `--platform=linux/amd64` option with Amazon Corretto.

### Exposed Ports

The following ports are exposed:

- `8080`: HTTP port
- `8443`: HTTPS port
- `9933`: Default SmartFox Server port
- `9933/udp`: Default SmartFox Server UDP port
- `5000`: AdminTool port

## GitHub Actions Workflow

This repository includes a GitHub Actions workflow that automates the build and push of the SmartFox Server Docker image. The workflow supports multi-platform builds using Docker Buildx.

### Tags

The workflow automatically tags Docker images based on versioning and branch events.

## License

This Docker image is provided under the [MIT License](LICENSE).

[Ref](https://github.com/timlien/docker-smartfox)
