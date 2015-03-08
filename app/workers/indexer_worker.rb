class IndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  # ElasticClient = Elasticsearch::Client.new host: 'localhost:9200', logger: Sidekiq.logger

  def perform(operation, record_id)
    Rails.logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
      when /index/
        record = Product.find(record_id)
        ElasticClient.index(index: Product.index_name, type: Product.document_type, id: record.id, body: record.as_indexed_json)
      when /delete/
        ElasticClient.delete index: Product.index_name, type: Product.document_type, id: record_id
      else
        raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
