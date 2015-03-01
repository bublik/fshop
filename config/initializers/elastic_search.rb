ElasticClient = Elasticsearch::Client.new({host: Rails.application.secrets.elastic_host,
                                           logger: Rails.logger,
                                           reload_connections: true})
Kaminari::Hooks.init
Elasticsearch::Model.client = ElasticClient

Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari