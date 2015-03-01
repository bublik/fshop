# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  product_id :text
#  username   :string(255)
#  email      :string(255)
#  message    :text
#  state      :integer          default(0)
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
  belongs_to :product
  acts_as_nested_set

  attr_accessor :feedback
  enum state: {pending: 0, deleted: 1, verified: 2}

  default_scope { where('questions.state != 1') }
  scope :newest, -> { joins(:product).order('questions.updated_at DESC').where(products:
                                                                                 {state: Product.states[:published],
                                                                                  is_active: true}) }
  scope :by_state, ->(state) { where(state: Question.states[state]) }

  validates_presence_of :username, :email, :message
  validates :product_id, presence: { if: :new_question? }

  def new_question?
    self.parent_id.blank? && !self.feedback
  end

end
