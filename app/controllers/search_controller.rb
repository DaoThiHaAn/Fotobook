class SearchController < ApplicationController
  def photos
    @search = params[:q]
    @results = Photo.none

    if @search.present?
      # Find all publicc photos and albums (title or description)
      # Loop through each token in the search string
      tokens = @search.split

      tokens.each do |token|
        pattern = "%#{token}%"
        @results = @results.or(Photo.where("title ILIKE :search OR description ILIKE :search", search: pattern).where(is_public: true))
      end

      @is_photo = true
    end
    render :index
  end

  def albums
    @search = params[:q]
    @results = Album.none

    if @search.present?
      # Find all publicc photos and albums (title or description)
      # Loop through each token in the search string
      tokens = @search.split

      tokens.each do |token|
        pattern = "%#{token}%"
        @results = @results.or(Album.where("title ILIKE :search OR description ILIKE :search", search: pattern).where(is_public: true))
      end

      @is_photo = false
    end
    render :index
  end
end
