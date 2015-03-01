# == Schema Information
#
# Table name: short_urls
#
#  id          :integer          not null, primary key
#  seo_url     :string(255)
#  full_url    :string(1024)
#  title       :string(255)
#  description :string(255)
#  keywords    :string(255)
#  style_typs  :text
#  filter      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class ShortUrl < ActiveRecord::Base

  validates_presence_of :seo_url, :full_url
  validates_length_of :full_url, maximum: 1024
  validates_length_of :title, maximum: 255
  validates_length_of :description, maximum: 255
  validates_length_of :keywords, maximum: 255
  validates_uniqueness_of :seo_url

  serialize :filter, Hash

  before_save :store_filter

  def store_filter
    url = self.full_url.to_s

    if url.match('/tag/')
      params = {'product' => {}}
      args = url.split('/')

      unless args[-2].eql?('tag')
        params['product'] = {args[-1] => [CGI.unescape(args[-2])]}
      else
        params['q'] = args[-1]
      end
    else
      params = Rack::Utils.parse_nested_query(url.split('?').last)
      params.delete('utf8')
    end

    unless params.blank?
      self.filter = params['product']
      self.filter['q'] = params['q'] if params['q']
    end
  end

end
