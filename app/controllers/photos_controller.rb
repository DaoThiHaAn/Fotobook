class PhotosController < ApplicationController
  # before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    # Show all photos in guest mode
    @photos = Photo.all.includes(:profile).order(updated_at: :desc)
  end

  def index_feeds
    # TODO: Show all photos in of people who u are following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @photos = Photo.where(user_id: following_ids).includes(:profile).order(updated_at: :desc)

    render :index
  end

def index_discover
    # Show all photos of people you are not following
    following_ids = Follow.where(follower_id: current_user.id).pluck(:followee_id)
    @photos = Photo.where.not(user_id: following_ids).includes(:profile).order(updated_at: :desc)

    render :index
end

  def index_user
    # TODO: show all photos in your own profile (only u can view)
    @photos = Photo.where(id: current_user.id).includes(:profile).order(updated_at: :desc)
    @is_public = false
    @target_person = Profile.where(user_id: current_user.id)
    render template: "profiles/show"
  end

def index_profile
    # TODO: show all of his public photos when visiting a user profile
    @photos = Photo.where(user_id: params[:profile_id], is_public: true).order(updated_at: :desc)
    @is_public = true
    @target_person = Profile.find_by(user_id: params[:profile_id])
    render template: "profiles/show"
end

  # GET /photos/1 or /photos/1.json
  def show
    # @photo = Photo.find(params[:id])
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy!

    respond_to do |format|
      format.html { redirect_to photos_path, status: :see_other, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.expect(photo: [ :image_path, :title, :description, :is_public, :hearts_count ])
    end
end
