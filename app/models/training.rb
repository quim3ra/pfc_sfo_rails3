class Training < ActiveRecord::Base
  belongs_to :player
  validate :only_one_ability_at_the_same_time
  validates_presence_of :ability
  validates_numericality_of :improvement, :only => :integer, :greater_than => 0
  validates_numericality_of :round_count, :only => :integer,
    :greater_than_or_equal_to => 0
  scope :last, lambda { |l| {:order => "created_at DESC", :limit => l}}
  scope :finished, :conditions => {:round_count => 0}
  scope :not_finished, :conditions => ['round_count > 0']
  attr_accessible :ability, :improvement, :round_count, :player

  #Add error player already training
  def only_one_ability_at_the_same_time
    unless self.player.trainings.not_finished.count == 0
      self.errors.add_to_base("The player already training")
    end
  end

  #Returns true if the training has finished
  def finished?
    self.round_count > 0
  end

  #Discount one round for finish the training
  def discount_round
    num = self.round_count
    num -= 1
    self.update_attribute(:round_count, num) if self.round_count > 0
    self
  end
end


# == Schema Information
#
# Table name: trainings
#
#  id          :integer         not null, primary key
#  player_id   :integer         not null
#  ability     :string(255)     not null
#  improvement :integer
#  round_count :integer
#  created_at  :datetime
#  updated_at  :datetime
#

