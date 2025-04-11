# ELK Stack Logging Demo

A centralized log ingesting system utilizing the Elastic Stack (Elasticsearch, Logstash, Kibana), and Grafana. Specifically configured to monitor and analyze [WordPress VIP HTTP request logs](https://docs.wpvip.com/logs/log-shipping/), providing a solution for log collection, processing, visualization, and AWS integration.

## Overview

This project used [Docker](https://www.docker.com/) to provide a containerized environment for centralized log processing, storage, and visualization.

It includes:

- **Infrastructure**: Docker Compose-based orchestration, service health checks, and dependency management.
- **Log collection**: Centralized ingestion with Logstash, AWS S3 integration, and local backup support.
- **Visualization**: Kibana and Grafana with pre-configured dashboards for real-time analysis.
- **Development setup**: Easy local environment configuration with `.env` support and sample data.

The stack is optimized for development and testing, with production deployments requiring additional security and scaling considerations.

## Prerequisites

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/).
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with [credentials](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html) set up (can be done via `aws configure`).
- Basic understanding of [Elastic Stack](https://www.elastic.co/elastic-stack) and [AWS S3](https://aws.amazon.com/s3/).

## Components

- **[Elasticsearch 8.12.2](https://www.elastic.co/elasticsearch/)**: Search and analytics engine
- **[Logstash 8.11.1](https://www.elastic.co/logstash/)**: Log processing and transformation
- **[Kibana 8.12.2](https://www.elastic.co/kibana/)**: Data visualization and exploration
- **[Grafana 10.2.3](https://grafana.com/)**: Additional visualization capabilities

## Getting Started

1. Clone the repository.
2. Copy the environment file:
   ```bash
   cp .env.example .env
   ```

3. Update the `.env` file with your configuration. This file contains environment variables that configure various aspects of the application. These variables are explained in the [`.env.example`](.env.example) file, but the following three are required:
   ```
   AWS_S3_BUCKET
   AWS_S3_REGION
   AWS_S3_PREFIX
   ```

4. Start the services:
   ```bash
   docker compose up -d
   ```

## Accessing Services

- **Kibana**: http://localhost:5601
- **Grafana**: http://localhost:3000
- **Elasticsearch**: http://localhost:9200

## Configuration Structure

### Logstash
- Configuration files are located in [`logstash/config/`](logstash/config)
- Pipeline configurations are in [`logstash/pipeline/`](logstash/pipeline)
- The sample pipeline is tailored to ingest HTTP logs using the [WordPress VIP shipped logs structure](https://docs.wpvip.com/logs/log-shipping/log-contents/).

### Grafana
- Provisioning configurations are in [`grafana/provisioning/`](grafana/provisioning). This will create a data source for Elasticsearch and a sample dashboard.
- Configured for anonymous access by default.

### Kibana
- Saved objects exported from the Kibana console (http://localhost:5601/app/management/kibana/objects) are stored in [`kibana/saved_objects`](kibana/saved_objects).
- After Kibana health check passes on start, an initialization script [`init-scripts.sh`](init-scripts.sh) will run in a [Docker curlimage](https://hub.docker.com/r/curlimages/curl) container and import the saved objects.

## AWS Integration

This project supports seamless AWS integration using the credentials and configuration files from your `~/.aws/` directory.

- By default, the container will use the `default` AWS profile. You can override this by setting the `AWS_PROFILE` environment variable in your `.env` file.
- Unless you're using a non-standard location, there's no need to explicitly set `AWS_SHARED_CREDENTIALS_FILE` or modify volume paths.
- Ensure that the selected profile has permission to access the S3 bucket and region specified in your `.env`.

Example:
```env
AWS_S3_BUCKET=my-s3-bucket
AWS_S3_REGION=us-east-1
AWS_S3_PREFIX=my-application/production
AWS_PROFILE=custom-profile
```

The bucket name and region should contain the same values configured in the [WordPress VIP HTTP request Log Shipping](https://docs.wpvip.com/logs/log-shipping/enable/#h-enable-http-request-log-shipping) feature of the [VIP Dashboard](https://docs.wpvip.com/vip-dashboard/).

## Environment Variables

The application uses environment variables to manage configurations. You can find a sample of these variables in the [`.env.example`](.env.example) file, which serves as a reference for what can be included in your own `.env` file.

## Security Notes

- Security features are disabled for demonstration purposes.
- In production, proper security measures should be implemented.

## Maintenance

### Starting Services
```bash
docker compose up -d
```

### Stopping Services
```bash
docker compose down

# Or stop and delete the volumes
# Warning: This will erase all previously ingested data and unsaved changes
docker compose down -v
```

### Viewing Logs
```bash
docker compose logs -f

# Or show them by service.
# Add --tail=0 if you only want to watch for new data
docker compose logs -f <logstash|elasticsearch|kibana|grafana>
```

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Create a new Pull Request.

## License

MIT License - see [LICENSE](LICENSE)
