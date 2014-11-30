class Airport < ActiveRecord::Base

  validates :name, presence:true
  validates :latitude, presence:true, if:"iata_faa.nil?"
  validates :longitude, presence:true, if:"iata_faa.nil?"

  validates :iata_faa, format:
    { with: /\A[A-Z]{3}\z/, message:"must be 3-letter acronym" },
    allow_blank:true
  validates :iata_faa, uniqueness:true

  validates :icao, format:
    { with: /\A[A-Z]{4}\z/, message:"must be 4-letter acronym" }

  geocoded_by :iata_faa
  after_validation :geocode, if: lambda { |a| a.latitude.nil? || a.longitude.nil? }

  def timezone
    NearestTimeZone.to(self.latitude, self.longitude)
  end

end
