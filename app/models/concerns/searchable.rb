module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    paginates_per 30
    index_name "products-#{Rails.env}" # how to remove index curl -XDELETE 'http://localhost:9200/products-development/'
    document_type "product"

    settings index: {number_of_shards: 5,
                     analysis: {
                       analyzer: {
                         analyzer_startswith: {
                           tokenizer: "keyword",
                           filter: "lowercase"
                         }
                       }
                     }} do
      mapping do
        indexes :price, type: 'integer'
        indexes :colour_list, type: 'multi_field' do
          indexes :colour_list, analyzer: 'keyword'
        end
        indexes :length_list, type: 'multi_field' do
          indexes :length_list, analyzer: 'keyword'
        end
        indexes :occasion_list, type: 'multi_field' do
          indexes :occasion_list, analyzer: 'keyword'
        end
        indexes :collar_type_list, type: 'multi_field' do
          indexes :collar_type_list, analyzer: 'keyword'
        end
        indexes :body_type_list, type: 'multi_field' do
          indexes :body_type_list, analyzer: 'keyword'
        end
        indexes :back_list, type: 'multi_field' do
          indexes :back_list, analyzer: 'keyword'
        end
        indexes :sleeve_type_list, type: 'multi_field' do
          indexes :sleeve_type_list, analyzer: 'keyword'
        end
        indexes :length_of_sleeve_list, type: 'multi_field' do
          indexes :length_of_sleeve_list, analyzer: 'keyword'
        end
        indexes :neckline_type_list, type: 'multi_field' do
          indexes :neckline_type_list, analyzer: 'keyword'
        end
        indexes :waistline_list, type: 'multi_field' do
          indexes :waistline_list, analyzer: 'keyword'
        end
        indexes :belt_type_list, type: 'multi_field' do
          indexes :belt_type_list, analyzer: 'keyword'
        end
        indexes :hemline_list, type: 'multi_field' do
          indexes :hemline_list, analyzer: 'keyword'
        end
        indexes :item_shape_list, type: 'multi_field' do
          indexes :item_shape_list, analyzer: 'keyword'
        end
        indexes :skirt_type_list, type: 'multi_field' do
          indexes :skirt_type_list, analyzer: 'keyword'
        end
        indexes :item_type_list, type: 'multi_field' do
          indexes :item_type_list, analyzer: 'keyword'
        end
        indexes :style_list, type: 'multi_field' do
          indexes :style_list, analyzer: 'keyword'
        end
        indexes :other_detail_list, type: 'multi_field' do
          indexes :other_detail_list, analyzer: 'keyword'
        end
        indexes :fabric_list, type: 'multi_field' do
          indexes :fabric_list, analyzer: 'keyword'
        end
      end

    end

    def self.create_index
      #http://localhost:9200/products-development/product/_mapping
      #http://localhost:9200/_mapping/product
      __elasticsearch__.client.indices.delete index: Product.index_name rescue nil
      __elasticsearch__.client.indices.create index: Product.index_name,
                                              body: {settings: Product.settings.to_hash, mappings: Product.mappings.to_hash}
    end

    def self.redindex_all
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
           "{'range' : {'price' : {'gte' : #{price['min'].to_i * 100}, 'lte' : #{price['max'].to_i * 100}}}}"
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
