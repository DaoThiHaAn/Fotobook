class AlbumsController < ApplicationController
    before_action :require_login!, except: [ :index, :show ]
    before_action :check_private, only: [ :show ]
    before_action :set_photo, only: %i[ show edit update destroy ]
    before_action -> { require_owner!(@photo) }, except: [ :index, :show ]

  # GET /albums or /albums.json
  def index
      # Show all public albums in guest mode
      @posts = Album.all.includes(profile: :user).where(is_public: true).order(updated_at: :desc)
      @is_photo = false # to render photo partial
  end

  def index_feeds
    # TODO: Show all albums of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @posts = Album.where(user_id: following_ids).includes(:profile).order(updated_at: :desc)
    @is_photo = false
    render :index
  end

  def index_discover
      # Show all albums of people you are not following
      following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
      @posts = Album.where.not(user_id: following_ids).includes(:profile).order(updated_at: :desc)
      @is_photo = false
      render :index
  end

  def index_user
    # TODO: show all albums in your own profile (only u can view)
    @target_person = current_user.profile
    @albums = @target_person.albums.order(updated_at: :desc)
    @is_public = false
    render template: "profiles/show"
  end

def index_profile
    # TODO: show all of his public albums when visiting a user profile
    @albums = Album.where(user_id: params[:profile_id], is_public: true).order(updated_at: :desc)
    @is_public = true
    @target_person = Profile.find_by(user_id: params[:profile_id])
    render template: "profiles/show"
end


  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy!

    respond_to do |format|
      format.html { redirect_to albums_path, status: :see_other, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:image_path, :title, :description, :is_public)
    end
end
