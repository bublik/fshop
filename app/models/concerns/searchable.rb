module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    paginates_per 30
    index_name "#{model_name.singular}-#{Rails.env}".downcase # how to remove index curl -XDELETE 'http://localhost:9200/products-development/'
    document_type model_name.singular
    inherited_class = self
    settings index: {number_of_shards: 5, #number_of_replicas: 1,
                     analysis: {analyzer: {analyzer_startswith: {tokenizer: 'keyword', filter: 'lowercase'}}}} do
      mapping do
        indexes :price, type: 'integer'
        inherited_class.send(:tag_types).each do |tag|
          index_name = "#{tag}_list".to_sym
          indexes index_name, type: 'multi_field' do
            indexes index_name, analyzer: 'keyword'
          end
        end
      end
    end

    def self.create_index
      #http://localhost:9200/products-development/product/_mapping
      #http://localhost:9200/_mapping/product
      __elasticsearch__.client.indices.delete(index: self.index_name) rescue nil
      __elasticsearch__.client.indices.create index: self.index_name,
                                              body: {settings: self.settings.to_hash, mappings: self.mappings.to_hash}

    end

    def self.redindex_all
      #Clothing.opened.find_each do |cl| IndexerWorker.perform_async(:index, cl.id) end #add to index after recreate index
      self.opened.collect { |record| record.save }
    end

    def self.search(q, page = 0) # perpage 30
      unless q.kind_of?(String)
        price = q['price']
        string_conditions = q.delete('q')
        tags = q.except('price')
        tags_condition = tags.collect { |k, v| {:terms => {"#{k}_list" => v}} }
        tags_condition = tags_condition.empty? ? nil : "#{tags_condition.to_json[1..-2]}"

        string_conditions = "'query' : { 'match' : { 'name' : '#{string_conditions}' } }," unless string_conditions.blank?
        price_condition = unless price.blank?
          "{'range' : {'price' : {'gte' : #{price['min'].to_i}, 'lte' : #{price['max'].to_i }}}}"
        else
          "{'range' : {'price' : {'gte' : 0}}}"
        end

        q = "{
          'query' : {
          'filtered' : {
            #{string_conditions}
            'filter' : {
              'bool' : {
               'must' : [
                 #{[price_condition, tags_condition].compact.join(',') }
              ,{ 'terms' : { 'is_active' : [true]}}, { 'terms' : { 'state' : ['published']}}
              ]
            }
           }
          }
        }
        }".gsub("'", "\"")
      else
        q = "{
          'query' : {
          'filtered' : {
            'filter' : {
              'bool' : {
               'must' : [{ 'terms' : { 'is_active' : [true]}}, { 'terms' : { 'state' : ['published']}}]
            }
           }
          }
        }
        }".gsub("'", "\"")
      end
      __elasticsearch__.search(q)
    end

    def self.related_products(product)
      tags_condition = product.cached_tags.collect { |k, v| {:terms => {k => v}} }
      tags_condition = tags_condition.empty? ? '' : tags_condition.to_json[1..-2]
      q = "{
          'query' : {
          'filtered' : {
            'filter' : {
              'bool' : {
                'should' : [
                 #{tags_condition}
                ],
                'must' : [
                        { 'terms' : { 'is_active' : [true]}},
                        { 'terms' : { 'state' : ['published']}}
                 ]
            }
           }
          }
        }
        }".gsub("'", "\"")
      __elasticsearch__.search(q).records
    end
  end
end
