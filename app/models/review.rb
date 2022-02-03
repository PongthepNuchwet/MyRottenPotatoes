class Review < ApplicationRecord
  belongs_to :moviegoer
  belongs_to :movie

  validates :movie_id, :presence => true
  validates_associated :movie
end
