# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string
#  preview    :text
#  body       :text
#  slug       :string
#  created_at :datetime
#  updated_at :datetime
#


class Blog < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  default_scope { order('blogs.id DESC') }
  validates_presence_of :title, :preview, :body

  def self.last_records(limit = 5)
    Rails.cache.fetch("blog_last_#{limit}", expires_in: 5.minutes) do
      self.limit(limit).to_a
    end
  end

  def self.flush_cache
    Rails.cache.delete_matched(/^blog_/)
  end
end
