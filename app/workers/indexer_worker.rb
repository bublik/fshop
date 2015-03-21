class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  # ElasticClient = Elasticsearch::Client.new host: 'localhost:9200', logger: Sidekiq.logger

  def perform(operation, record_id)
    Rails.logger.debug [operation, "ID: #{record_id}"]
    record = Product.find(record_id)
    attributes = {
      index: record.class.index_name, type: record.class.document_type, id: record.id
    }
    case operation.to_s
      when /index/
        ElasticClient.index(attributes.merge(body: record.as_indexed_json))
      when /delete/
        ElasticClient.delete(attributes)
      else
        raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
