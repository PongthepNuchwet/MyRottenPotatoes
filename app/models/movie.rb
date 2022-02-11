class Movie < ApplicationRecord
    has_many :reviews
    has_many :moviegoers, :through => :reviews
    before_save :capitalize_title

    scope :movies_with_good_reviews, lambda {|threshold|
      Movie.joins(:reviews).group(:movie_id).having(['AVG(reviews.potatoes) > ?', threshold.to_i])
  }

    scope :for_kids, lambda {
      Movie.where(rating: ['G','PG'])
    }

    scope :recently_reviewed, lambda { |n|
      Movie.joins(:reviews).where(['reviews.created_at >= ?',n.to_i.days.ago]).uniq
      }

    def self.find_in_tmdb(string)
      Tmdb::Api.key("a0de66eb6350860129a9073319dbed4c")
      begin
        Tmdb::Movie.find(string)
      rescue NoMethodError => tmdb_gem_exception
        if Tmdb::Api.response['code'] == '401'
          raise Movie::InvalidKeyError, 'Invalid API key'
        else
          raise tmdb_gem_exception
        end
      end
    end

    def capitalize_title
      self.title = self.title.split(/\s+/).map(&:downcase).
        map(&:capitalize).join(' ')
    end
    
    def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings

    validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
      :unless => :grandfathered?
    def released_1930_or_later
      errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end
    
    @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
      release_date && release_date >= @@grandfathered_date
    end
end
